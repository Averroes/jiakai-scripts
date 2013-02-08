#!/bin/bash
# $File: toggle-touchpad.sh
# $Date: Sun Nov 18 10:25:35 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>
val=$(synclient -l | grep -c 'TouchpadOff.*=.*0')
synclient TouchpadOff=$val
[ $val == "1" ] && val="off" || val="on"
echo "Touchpad: $val" | ~/script/send-notify.sh
