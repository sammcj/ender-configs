#!/usr/bin/env bash

# This script syncs files from the rockpi Klipper host to my local machine / this git repo for version control.

SSH_USER=${SSH_USER:-octo}
SSH_HOST=${SSH_HOST:-rockpi.local}
LOCAL_PATH=${LOCAL_PATH:-klipper}
EXCLUDES=(
  octoeverywhere.*
  *.git
  *.github
  *.DS_Store
  *.backup
  printer-20*
  *.theme
  *.bkp
  *.tmp
)

# Create the rsync exclude string.
EXCLUDE_STRING=""
for EXCLUDE in "${EXCLUDES[@]}"; do
  EXCLUDE_STRING="${EXCLUDE_STRING} --exclude=${EXCLUDE}"
done

DEBUG=${DEBUG:-false}
if [[ $DEBUG == true ]]; then
  set -x
fi

# shellcheck disable=SC2086
echo "Files on remote host not in ${LOCAL_PATH}:"
if [[ $(rsync -avz --progress --dry-run $EXCLUDE_STRING $EXCLUDE_STRING "${SSH_USER}@${SSH_HOST}":/home/octo/printer_data/config/ "${LOCAL_PATH}/" | wc -l) -gt 4 ]]; then
  echo "Do you want to sync these files from remote host to local machine?"
  read -p "Sync files from remote host? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # shellcheck disable=SC2086
    rsync -avz --progress $EXCLUDE_STRING "${SSH_USER}@${SSH_HOST}":/home/octo/printer_data/config/ "${LOCAL_PATH}/"

    # Offer to commit and push any changes to git, default to no.
    if [[ $(git status --porcelain | grep "$LOCAL_PATH" | wc -l) -gt 0 ]]; then
      echo "Git repo has changes:"
      git status --porcelain
      read -p "Commit and push changes to git? [y/N] " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add klipper/
        git commit -m "Update Klipper configs"
        git push
      fi
    fi
  fi

fi

# List any files in "${LOCAL_PATH}/" that are not on the remote host.
echo "Files in ${LOCAL_PATH} not on remote host:"
# shellcheck disable=SC2086
rsync -avz --progress --dry-run $EXCLUDE_STRING "${LOCAL_PATH}/" "${SSH_USER}@${SSH_HOST}":/home/octo/printer_data/config/

# Only prompt if there are files not on the remote host.
# shellcheck disable=SC2086
if [[ $(rsync -avz --progress --dry-run $EXCLUDE_STRING "${LOCAL_PATH}/" "${SSH_USER}@${SSH_HOST}":/home/octo/printer_data/config/ | wc -l) -gt 4 ]]; then
  # Offer to rsync the files to the remote host, default to no.
  read -p "Sync files to remote host? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # shellcheck disable=SC2086
    rsync -avz --progress $EXCLUDE_STRING "${LOCAL_PATH}/" "${SSH_USER}@${SSH_HOST}":/home/octo/printer_data/config/
  fi
fi
