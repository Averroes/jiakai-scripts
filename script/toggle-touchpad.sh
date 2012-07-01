#!/bin/bash
val=$(synclient -l | grep -c 'TouchpadOff.*=.*0')
synclient TouchpadOff=$val
[ $val == "1" ] && val="off" || val="on"
echo "Touchpad: $val" | ~/script/send-notify.sh
