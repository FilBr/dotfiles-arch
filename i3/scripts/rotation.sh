#!/bin/sh
# Auto rotate screen based on device orientation

# Receives input from monitor-sensor (part of iio-sensor-proxy package)
# Screen orientation and launcher location is set based upon accelerometer position
# Launcher will be on the left in a landscape orientation and on the bottom in a portrait orientation
# This script should be added to startup applications for the user

# Clear sensor.log so it doesn't get too long over time
> $HOME/.cache/sensor.log

# Launch monitor-sensor and store the output in a variable that can be parsed by the rest of the script
monitor-sensor > $HOME/.cache/sensor.log 2>&1 &

# Parse output or monitor sensor to get the new orientation whenever the log file is updated
# Possibles are: normal, bottom-up, right-up, left-up
# Light data will be ignored
while inotifywait -e modify $HOME/.cache/sensor.log; do
# Read the last line that was added to the file and get the orientation
ORIENTATION=$( tail -n 1 $HOME/.cache/sensor.log | grep 'orientation' | grep -oE '[^ ]+$')

# Avoid misdetection of portrait mode while rotating device
if [ "$ORIENTATION" = "right-up" ] || [ "$ORIENTATION" = "left-up" ]
then
  sleep 1
  ORIENTATION=$( tail -n 1 $HOME/.cache/sensor.log | grep 'orientation' | grep -oE '[^ ]+$')
fi

INPUTS=$( xinput | grep pointer | tr -s " " | cut -f 2 -d "=" | cut -f 1 | tail -n +2 )

# Set the actions to be taken for each possible orientation
case "$ORIENTATION" in
normal)
xrandr --output eDP-1-1 --rotate normal
for input_device in $INPUTS
do
  echo "Rotating "; xinput list --short $input_device
  xinput set-prop $input_device --type=float "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
done ;;
bottom-up)
xrandr --output eDP-1-1 --rotate inverted
for input_device in $INPUTS
do
  echo "Rotating "; xinput list --short $input_device
  xinput set-prop $input_device --type=float "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
done ;;
right-up)
xrandr --output eDP-1-1 --rotate right
for input_device in $INPUTS
do
  echo "Rotating "; xinput list --short $input_device
  xinput set-prop $input_device --type=float "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
done ;;
left-up)
xrandr --output eDP-1-1 --rotate left
for input_device in $INPUTS
do
  echo "Rotating "; xinput list --short $input_device
  xinput set-prop $input_device --type=float "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
done ;;
esac
done
