#!/usr/bin/env bash

set -ex

# Set date variable
DATE=$(date +%Y-%m-%d)

PYTHON_BIN="${HOME}/klippy-env/bin/python3"
GRAPH_SCRIPT="${HOME}/klipper/scripts/calibrate_shaper.py"
RUN_COMMAND="${PYTHON_BIN} ${GRAPH_SCRIPT}"

# Set destination directory
DEST_DIR="/home/octo/calibration"
DEST_DIR_DATE="${DEST_DIR}/${DATE}"

# Create a new directory in the destination directory
mkdir -p "${DEST_DIR_DATE}/csv"

# Log files
CALIBRATION_LOG="${DEST_DIR_DATE}/run.log"
RECOMMENDATIONS="${DEST_DIR_DATE}/recommendations.txt"

cd "$DEST_DIR_DATE"

touch "$CALIBRATION_LOG"
touch "$RECOMMENDATIONS"

# Copy all .csv files created today in /tmp/ to $DEST_DIR/$DATE/csv/
find /tmp/ -maxdepth 1 -type f -name "*.csv" -newermt "${DATE} 00:00:00" ! -newermt "${DATE} 23:59:59" -exec cp {} "${DEST_DIR_DATE}/csv/" \;

# Loop over each csv file in $DEST_DIR/$DATE/csv/ and run calibrate_shaper.py on it
for file in "${DEST_DIR_DATE}/csv/"*.csv; do
  eval "$(
    FILENAME=$(basename "$file")
    FILENAME_NO_EXT="${FILENAME%.*}"
    FILENAME_LOG="${FILENAME_NO_EXT}.log"
    output=$(

      # # skip the files if the png already exists
      # if [ -f "${FILENAME_NO_EXT}-${DATE}.png" ]; then
      #   echo "Skipping ${FILENAME_NO_EXT} as ${FILENAME_NO_EXT}-${DATE}.png already exists"
      # else

      $RUN_COMMAND "$file" -o "${FILENAME_NO_EXT}-${DATE}.png" >>"${FILENAME_LOG}" &

      # grep for the line that contains "recommended shaper" and get axis from the filename and echo them
      RECOMMENDED_SHAPER=$(grep "recommended shaper" "${FILENAME_LOG}" | tee -a "$FILENAME_LOG")

      echo -e "Axis file: $FILENAME_LOG \n - $RECOMMENDED_SHAPER \n" >>"$RECOMMENDATIONS"

      # fi
    )

    echo "$output" >>"$CALIBRATION_LOG"
  )" &
done

wait # wait for all background processes to finish

# Cleanup
rm -rf "${DEST_DIR_DATE}/csv"

ls -la "${DEST_DIR_DATE}/" >>"$CALIBRATION_LOG"

echo "You can now run the following command to copy the graphs from your local machine:" >>"$CALIBRATION_LOG"
echo "rsync -avr root@rockpi:${DEST_DIR_DATE} /Users/samm/git/sammcj/ender-configs/ender-5-s1/calibration/ --partial --progress" >>"$CALIBRATION_LOG"

cat "$CALIBRATION_LOG"
