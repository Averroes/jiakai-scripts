#!/bin/bash -e
# $File: setup-display.sh
# $Date: Sat Jul 12 15:32:45 2014 -0700
# $Author: jiakai <jia.kai66@gmail.com>

screen_num=0

xrandr -q | awk '/ connected/ {printf "%s ", $1; getline; print $1}' | \
	while read device mode
	do
		if [ "$screen_num" -eq 0 ]
		then
			basic=$device
			xrandr --output "$device" --mode $mode
		else
			xrandr --output "$device" --mode $mode --right-of "$basic"
			break
		fi
		screen_num=$(($screen_num + 1))
	done
