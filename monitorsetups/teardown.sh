#!/bin/bash
xrandr --output DP1-1 --off
xrandr --output DP1-2-1 --off
xrandr --output DP1-2-8 --off
sleep 3
xrandr --output eDP1 --auto --primary
herbstclient detect_monitors
