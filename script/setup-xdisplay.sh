#!/bin/bash -e
# $File: setup-screen.sh
# $Date: Fri Jun 29 00:23:34 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

LAPTOP=LVDS1
SCREEN=VGA1

xrandr -q | grep "$SCREEN" >/dev/null || exit

xrandr --output "$LAPTOP" --mode 1366x768
xrandr --output "$SCREEN" --mode 1920x1080 --right-of "$LAPTOP"
