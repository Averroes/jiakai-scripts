#!/bin/bash -e
# $File: setup-display.sh
# $Date: Sat Aug 03 22:01:57 2013 +0800
# $Author: jiakai <jia.kai66@gmail.com>

LAPTOP=LVDS1
SCREEN=VGA1

mode=$(xrandr -q | awk '/VGA1/ {getline; print $0; }')

[ -z "$mode" ] && exit

mode=$(echo $mode | cut -d' ' -f 1)

xrandr --output "$LAPTOP" --mode 1366x768
xrandr --output "$SCREEN" --mode $mode --right-of "$LAPTOP"
