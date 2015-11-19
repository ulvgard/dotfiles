#!/bin/bash
xrandr --output DP1-1 --off
xrandr --output DP1-2 --off
xrandr --output eDP1 --auto --primary

herbstclient set_monitors 1920x1080+0+0

# find the panel
panel="/home/tobias/.config/herbstluftwm/panel.sh"
[ -x "$panel" ] || panel=/etc/xdg/herbstluftwm/panel.sh
for monitor in $(herbstclient list_monitors | cut -d: -f1) ; do
    # start it on each monitor
    $panel $monitor &
done
