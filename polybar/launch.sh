#!/bin/sh

# Terminate already running bar instances
killall -u $(whoami) -q polybar

# Wait until the processes have been shut down
while pgrep -u $(whoami) -x polybar >/dev/null; do sleep 1; done

# Launch polybar
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload default &
  done
else
  polybar --reload default &
fi


echo "Bars launched."
