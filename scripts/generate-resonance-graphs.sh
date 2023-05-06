#!/usr/bin/env bash

# This script can be used to trigger, move and summarise resonance graph generation from the csv files

# Set date variable
DATE=$(date +%Y-%m-%d)
PYTHON_BIN=$HOME/klippy-env/bin/python3
GRAPH_SCRIPT=${HOME}/klipper/scripts/calibrate_shaper.py
RUN_COMMAND="$PYTHON_BIN $GRAPH_SCRIPT"
DEST_DIR="/home/octo/calibration"
DEST_DIR_DATE="${DEST_DIR}/${DATE}"
RESONANCES_LOG="${DEST_DIR_DATE}/resonances-${DATE}.log"
FILENAME=$(basename "$file")
FILENAME_NO_EXT="${FILENAME%.*}"
DEBUG=${DEBUG:-false}
INTERACTIVE=${INTERACTIVE:-true}

if [[ "$DEBUG" = true ]]; then
  echo "Debug enabled"
  set -x
fi

mkdir -p "$DEST_DIR_DATE" && cd "$DEST_DIR_DATE" || exit

# check if RESONANCES_LOG exists, if so move them to .old and create new ones
if [ -f "$RESONANCES_LOG" ]; then
  mv "$RESONANCES_LOG" "$RESONANCES_LOG.old"
fi

touch "$RESONANCES_LOG"

# Copy all .csv files created today in /tmp/ to $DEST_DIR/$DATE/
find /tmp/ -maxdepth 1 -type f -name "*.csv" -newermt "${DATE} 00:00:00" ! -newermt "${DATE} 23:59:59" -exec cp {} "${DEST_DIR_DATE}/" \;

# Loop over each csv file in $DEST_DIR/$DATE/ and run calibrate_shaper.py on it
for file in "$DEST_DIR_DATE"/*.csv; do
  eval "$(
    output=$(

      # skip the files if the png already exists
      if [ -f "${FILENAME_NO_EXT}-${DATE}.png" ]; then
        echo "${FILENAME_NO_EXT} as ${FILENAME_NO_EXT}-${DATE}.png already exists, skipping..."
      else
        eval $RUN_COMMAND "$file" -o "${FILENAME_NO_EXT}-${DATE}.png" &
      fi
    )

    echo "$output" >>"$RESONANCES_LOG"
  )"
done

echo "Waiting for background processes to finish..."
wait # wait for all background processes to finish

for file in "$DEST_DIR_DATE"/resonances_*.log; do
  # grep for the line that contains "recommended shaper" and get axis from the filename and echo them
  RECOMMENDED_SHAPER=$(
    grep -i 'Recommended shaper' "$file"
  )

  SHAPER=$(
    echo "$RECOMMENDED_SHAPER" | cut -d " " -f 4
  )

  # Find the max accel (the string after 'Recommended shaper' in $RECOMMENDED_SHAPER) and echo it
  RECOMMENDED_ACCEL=$(
    grep -i "To avoid too much smoothing with '$SHAPER'" "$file"
  )

  # Append the recommended shaper and accel to the log file
  echo -e "$file \n - $RECOMMENDED_SHAPER \n" | tee -a "$RESONANCES_LOG"
  echo -e "$file \n - $RECOMMENDED_ACCEL \n" | tee -a "$RESONANCES_LOG"
done

# Cleanup
rm -rf "$DEST_DIR_DATE"/*.csv
ls -la "${DEST_DIR_DATE}/" >>"$RESONANCES_LOG"

echo "This output was generated from generate-resonance-graphs.sh - https://github.com/sammcj/ender-configs/blob/main/scripts/generate-resonance-graphs.sh " >>"$RESONANCES_LOG"

echo "Completed."

if [[ "$INTERACTIVE" = true ]]; then
  echo "Would you like to add a note to the recommendations log? (y/n)"
  read -r COMMENT
  if [ "$COMMENT" = "y" ]; then
    echo "Enter your note:"
    read -r COMMENT
    echo "${DATE} - ${COMMENT}" >>"$RESONANCES_LOG"
  fi
fi

echo "Log written to ${RESONANCES_LOG}"
echo "---"
echo "You can rsync these back to your local machine, e.g."
echo "rsync -avr root@rockpi:${DEST_DIR_DATE} /Users/samm/git/sammcj/ender-configs/ender-5-s1/calibration/ --partial --progress"
