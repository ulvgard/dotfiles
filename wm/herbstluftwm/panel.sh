#!/bin/bash

# disable path name expansion or * will be expanded in the line
# cmd=( $line )
set -f

monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi
# geometry has the format: WxH+X+Y
x=${geometry[0]}
y=${geometry[1]}
panel_width=${geometry[2]}
panel_height=16
font="-artwiz-snap-*-*-*-*-10-*-*-*-*-*-*-"

PING="#CC0066"
ORANGE="#FF6600"
GREEN="#009933"
BLUE="#85A3C2"

bgcolor="#111111"
selbg="#111111"
selfg=$ORANGE



ICON_COLOR="#909090"

icon() {
	echo "^fg($ICON_COLOR)^i($1)^fg()"                                         
}


MEMICON=$(icon "/home/tobias/.icons/dzen/mem.xbm")
CPUICON=$(icon "/home/tobias/.icons/dzen/load.xbm")



####
# Try to find textwidth binary.
# In e.g. Ubuntu, this is named dzen2-textwidth.
if [ -e "$(which textwidth 2> /dev/null)" ] ; then
    textwidth="textwidth";
elif [ -e "$(which dzen2-textwidth 2> /dev/null)" ] ; then
    textwidth="dzen2-textwidth";
else
    echo "This script requires the textwidth tool of the dzen2 project."
    exit 1
fi
####
# true if we are using the svn version of dzen2
dzen2_version=$(dzen2 -v 2>&1 | head -n 1 | cut -d , -f 1|cut -d - -f 2)
if [ -z "$dzen2_version" ] ; then
    dzen2_svn="true"
else
    dzen2_svn=""
fi

function uniq_linebuffered() {
    awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}

  
herbstclient pad $monitor $panel_height
{
    # events:
    #mpc idleloop player &
    while true ; do
        date +'date ^fg(#efefef)%H:%M^fg(#909090), %Y-%m-^fg(#efefef)%d'
        sleep 1 || break
    done > >(uniq_linebuffered)  &
    childpid=$!
    herbstclient --idle
    kill $childpid
} 2> /dev/null | {
    TAGS=( $(herbstclient tag_status $monitor) )
    visible=true
    date=""
    windowtitle=""
    while true ; do
        bordercolor="#26221C"
        separator="^bg()^fg($selbg)|"
        # draw tags
        for i in "${TAGS[@]}" ; do
            case ${i:0:1} in
                '#')
                    echo -n "^bg($selbg)^fg($selfg)"
                    ;;
                '+')
                    echo -n "^bg(#9CA668)^fg(#141414)"
                    ;;
                ':')
                    echo -n "^bg()^fg(#ffffff)"
                    ;;
                '!')
                    echo -n "^bg(#FF0675)^fg(#141414)"
                    ;;
                *)
                    echo -n "^bg()^fg(#ababab)"
                    ;;
            esac
            if [ ! -z "$dzen2_svn" ] ; then
                echo -n "^ca(1,herbstclient focus_monitor $monitor && "'herbstclient use "'${i:1}'") '"${i:1} ^ca()"
            else
                echo -n " ${i:1} "
            fi

        done


#==~=======~==
# CPU
# ==~===~=====

		#echo -n "$separator"		
		#cpu =$(gcpubar -c 1 -bg '#222222' -fg $ORANGE)
		#echo -n "$CPUICON $cpu"

#==~=======~==
# MEM
# ==~===~=====

        echo -n "$separator"
		tot=$(free -m | awk '/Mem:/ { print $2 }')
		free=$(free -m | awk '/buffers\/cache/ { print $3 }')
		mem=$(bc -l <<< "$free/$tot*100" | sed -re 's#\..*##')
		echo -n "$MEMICON $mem%"

#==~=======~==
# BATTERY
# ==~===~=====
		acpi=$(acpi -i)			
		battime=$(echo $acpi | sed -re 's#[^,]*, ([[:digit:]]+)%.*#\1#')
		if echo $acpi | grep -q "Discharging"
		then
			btime=$(acpi -b | awk '{print $5}' | xargs echo)
		else
			btime=""
		fi
	
		if echo $acpi | grep -q "Charging"
		then
			BATTERYICON=$(icon "/home/tobias/.icons/dzen/ac-charging.xbm")
		elif echo $acpi | grep -q "Discharging"
		then
			if [ "$battime" -gt "80" ]; then
				BATTERYICON=$(icon "/home/tobias/.icons/dzen/battery-full.xbm")
			elif [ "$battime" -gt "40" ]; then
				BATTERYICON=$(icon "/home/tobias/.icons/dzen/battery-low.xbm")
			else
				BATTERYICON=$(icon "/home/tobias/.icons/dzen/battery-empty.xbm")
			fi
		else
			BATTERYICON=$(icon "/home/tobias/.icons/dzen/ac-charged.xbm")
		fi

		echo -n "  $BATTERYICON $battime% $btime"

        #echo -n "$separator"
		#echo -n "^bg()^fg() $(tail -n -1 /home/tobias/projects/stocken/portfolio.txt)"

        #echo -n "$separator"
        #echo -n "^bg()^fg() ${windowtitle//^/^^}"

        # small adjustments
        right="$separator^bg() $date $separator"
        right_text_only=$(echo -n "$right"|sed 's.\^[^(]*([^)]*)..g')
        # get width of right aligned text.. and add some space..
        width=$($textwidth "$font" "$right_text_only    ")
        echo -n "^pa($(($panel_width - $width)))$right"
        echo
        # wait for next event
        read line || break
        cmd=( $line )
        # find out event origin
        case "${cmd[0]}" in
            tag*)
                #echo "reseting tags" >&2
                TAGS=( $(herbstclient tag_status $monitor) )
                ;;
            date)
                #echo "reseting date" >&2
                date="${cmd[@]:1}"
                ;;
            quit_panel)
                exit
                ;;
            togglehidepanel)
                currentmonidx=$(herbstclient list_monitors |grep ' \[FOCUS\]$'|cut -d: -f1)
                if [ -n "${cmd[1]}" ] && [ "${cmd[1]}" -ne "$monitor" ] ; then
                    continue
                fi
                if [ "${cmd[1]}" = "current" ] && [ "$currentmonidx" -ne "$monitor" ] ; then
                    continue
                fi
                echo "^togglehide()"
                if $visible ; then
                    visible=false
                    herbstclient pad $monitor 0
                else
                    visible=true
                    herbstclient pad $monitor $panel_height
                fi
                ;;
            reload)
                exit
                ;;
            focus_changed|window_title_changed)
                windowtitle="${cmd[@]:2}"
                ;;
            #player)
            #    ;;
        esac
    done



} 2> /dev/null | dzen2 -w $panel_width -x $x -y $y -fn "$font" -h $panel_height \
    -ta l -bg "$bgcolor" -fg '#efefef'