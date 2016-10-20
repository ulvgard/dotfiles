#!/bin/bash
xrandr --output eDP1 --off
sleep 3
xrandr --output DP1-1 --auto  --rotate right --primary
xrandr --output DP1-2 --auto  --right-of DP1-1 --rotate right
xrandr --output DP1-3 --auto  --right-of DP1-2 --rotate left

herbstclient detect_monitors
