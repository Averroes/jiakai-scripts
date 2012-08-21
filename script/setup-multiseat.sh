#!/bin/bash -e
# $File: setup-multiseat.sh
# $Date: Fri Jul 13 10:39:09 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

sudo -b Xephyr :2 \
	-keybd evdev,,device=/dev/input/by-id/usb-USB_USB_Keykoard-event-kbd \
	-mouse evdev,,device=/dev/input/by-id/usb-15d9_USB_OPTICAL_MOUSE-event-mouse \
	-screen 1920x1080

sleep 1

export DISPLAY=:2

sakura --config-file=multiseat.conf &

exec xmonad

