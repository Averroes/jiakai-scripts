#!/bin/bash -e
# $File: close-display.sh
# $Date: Fri Jan 11 21:36:22 2013 +0800
# $Author: jiakai <jia.kai66@gmail.com>

SCREEN=VGA1

xrandr -q | grep "$SCREEN" >/dev/null || exit

xrandr --output "$SCREEN" --off
