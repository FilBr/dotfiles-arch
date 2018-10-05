#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload top_bar &
    MONITOR=$m polybar --reload bot_bar &
  done
else
  polybar --reload top_bar &
  polybar --reload bot_bar &
fi
# polybar top_bar -r &
