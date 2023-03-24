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

# A basic function that checks a provided file for any potential secrets such as passwords, API keys, etc.
function checkSecrets() {

  # Add any false positives strings that look like secrets to this array.
  ALLOWLIST=(
    'false positive secret'
  )

  for FILE in "${LOCAL_PATH}"/*; do
    # Check if the secret string is in the allowlist.
    if grep -n -q -E "password|api_key|token" "$FILE" | grep -q -F -v -f <(printf '%s ' "${ALLOWLIST[@]}"); then
      echo "!!!WARNING!!!: Potential secrets found in $FILE"
      echo "Check the file for any potential secrets and remove them before syncing to the remote host or add to the allowlist in this script."
      exit 1
    fi
  done
}

# Rsync all files from /home/octo/printer_data/config to the klipper/ directory in this repo, excluding any .git directories.
# shellcheck disable=SC2086
rsync -avz --progress $EXCLUDE_STRING "${SSH_USER}@${SSH_HOST}":/home/octo/printer_data/config/ "${LOCAL_PATH}/"

# List any files in "${LOCAL_PATH}/" that are not on the remote host.
echo "Files in ${LOCAL_PATH} not on remote host:"
# shellcheck disable=SC2086
rsync -avz --progress --dry-run $EXCLUDE_STRING "${LOCAL_PATH}/" "${SSH_USER}@${SSH_HOST}":/home/octo/printer_data/config/

# Only prompt if there are files not on the remote host.
if [[ $(rsync -avz --progress --dry-run $EXCLUDE_STRING "${LOCAL_PATH}/" "${SSH_USER}@${SSH_HOST}":/home/octo/printer_data/config/ | wc -l) -gt 4 ]]; then
  # Offer to rsync the files to the remote host, default to no.
  read -p "Sync files to remote host? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # shellcheck disable=SC2086
    rsync -avz --progress $EXCLUDE_STRING "${LOCAL_PATH}/" "${SSH_USER}@${SSH_HOST}":/home/octo/printer_data/config/
  fi
fi

# Offer to commit and push any changes to git, default to no.
if [[ $(git status --porcelain | grep "$LOCAL_PATH" | wc -l) -gt 0 ]]; then
  echo "Git repo has changes:"
  git status --porcelain
  read -p "Commit and push changes to git? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    checksecrets
    git add klipper/
    git commit -m "Update Klipper configs"
    git push
  fi
fi
