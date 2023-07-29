#!/usr/bin/env bash

# This script syncs files from the rockpi Klipper host to my local machine / this git repo for version control.

DEBUG=${DEBUG:-false}
if [[ $DEBUG == true ]]; then
  set -x
fi

SSH_USER=${SSH_USER:-octo}
SSH_HOST=${SSH_HOST:-rockpi.local}
LOCAL_PATH=${LOCAL_PATH:-klipper}
PRINTER_CONFIG_PATH=${PRINTER_CONFIG_PATH:-/home/octo/printer_data/config}

# Files to exclude from rsync.
EXCLUDES=(
  octoeverywhere.cfg
  zippy-klipper_config
  jschuh-klipper-macros
  .git/**
  .github
  .DS_Store
  .backup
  printer-20*
  .theme
  .bkp
  .tmp
)

# Fix the excludes so they work with rsync.
for i in "${!EXCLUDES[@]}"; do
  EXCLUDES[$i]="${EXCLUDES[$i]//\*/\*}"
  EXCLUDES[$i]="${EXCLUDES[$i]//\~\//}"
done

# Create the rsync exclude string.
for EXCLUDE in "${EXCLUDES[@]}"; do
  EXCLUDE_STRING="${EXCLUDE_STRING} --exclude=${EXCLUDE}"
done

# Strip the leading space off the exclude string.
EXCLUDE_STRING=$(echo "$EXCLUDE_STRING" | sed -e 's/^[[:space:]]*//')

# if ./ is found in the path, strip it off.

# Setup rsync command strings
DRY_RUN_FLAG="--dry-run"
set -x
LOCAL_TO_REMOTE="$(rsync -avz "${EXCLUDE_STRING}" "${LOCAL_PATH}"/ "${SSH_USER}"@"${SSH_HOST}":"${PRINTER_CONFIG_PATH}"/ $DRY_RUN_FLAG)"
REMOTE_TO_LOCAL="$(rsync -avz "${EXCLUDE_STRING}" "${SSH_USER}"@"${SSH_HOST}":"${PRINTER_CONFIG_PATH}" "${LOCAL_PATH}"/ $DRY_RUN_FLAG)"

# echo out the command to run and wait for user input.
echo Running command: "$LOCAL_TO_REMOTE"
echo "Running command: $REMOTE_TO_LOCAL"

# strip any leading whitespace
NUM_ITEMS=$(echo "$LOCAL_TO_REMOTE" | wc -l | sed -e 's/^[[:space:]]*//')

if [[ $NUM_ITEMS -gt 4 ]]; then
  read -p "Do you want to sync these files from remote host to local machine? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    DRY_RUN_FLAG=''
    $REMOTE_TO_LOCAL

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

# DRY_RUN_FLAG="--dry-run"
# if [[ $($LOCAL_TO_REMOTE | wc -l) -gt 4 ]]; then
#   read -p "Do you want to sync these files from local machine to remote host? [y/N] " -n 1 -r
#   echo
#   if [[ $REPLY =~ ^[Yy]$ ]]; then
#     DRY_RUN_FLAG=""
#     $LOCAL_TO_REMOTE
#   fi
# fi
