#!/bin/sh

# Check prerequisites
for i in pgrep polybar whoami xrandr; do
    if [ ! "$(command -v $i)" ]; then
        echo "error: prerequisite $i not found in PATH" >&2
        exit 1
    fi
done

# Terminate already running bar instances
kill $(pgrep -u "$(whoami)" polybar)

# Wait until the processes have been shut down
while pgrep -u "$(whoami)" polybar >/dev/null; do sleep 1; done

# Launch polybar
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m setsid polybar -l error --reload default &
  done
else
  setsid polybar -l error --reload default &
fi

echo "Bars launched."
