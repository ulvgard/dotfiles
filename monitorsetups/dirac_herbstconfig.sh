#!/bin/bash
if xrandr | grep -q "DP1-1 connected"; then
    herbstclient set_monitors 1920x1200+0+0 1920x1080+1920+0 1920x1200+3840+0
else
    herbstclient set_monitors 1920x1080+0+0
fi
