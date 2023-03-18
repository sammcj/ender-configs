#!/usr/bin/env bash
PORT=${PORT:-9876}
WEBCAM=${WEBCAM:-/dev/video5}
v4l2-ctl -d "$WEBCAM" --set-ctrl=power_line_frequency=1,focus_auto=0,focus_absolute=30
/usr/local/bin/ustreamer --port=$PORT --host=0.0.0.0 --process-name-prefix ustreamer-0 --buffers=3 --resolution=1280x960 --device="$WEBCAM" --quality=80 --workers=2 --encoder=hw --slowdown --desired-fps=20
