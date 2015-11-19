#!/bin/bash
if xrandr | grep -q "DP1-1 connected"
then
	xrandr --output eDP1 --off
    sleep 1
	xrandr --output DP1-1 --off
	sleep 1
	xrandr --output DP1-2 --off
	sleep 2	
    xrandr --output eDP1 --auto 
	xrandr --output DP1-2 --auto --left-of eDP1 
	xrandr --output DP1-1 --auto --right-of eDP1 
    sleep 1
    herbstclient set_monitors 1920x1080+1920+0 1920x1200+0+0 1920x1200+3840+0

    # find the panel
    panel="/home/tobias/.config/herbstluftwm/panel.sh"
    [ -x "$panel" ] || panel=/etc/xdg/herbstluftwm/panel.sh
    for monitor in $(herbstclient list_monitors | cut -d: -f1) ; do
        # start it on each monitor
        $panel $monitor &
    done


    setxkbmap -layout "us,se" -option "grp: caps_toggle"
    setxkbmap -device 14 -layout "us,se" -option "grp: caps_toggle"

fi
