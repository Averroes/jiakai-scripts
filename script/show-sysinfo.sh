#!/bin/bash -e
# $File: show-sysinfo.sh
# $Date: Tue Apr 16 20:10:42 2013 +0800
# $Author: jiakai <jia.kai66@gmail.com>

notify-send "System Info" "$(
date; echo -e '\n'; 
acpi;
cat /proc/acpi/battery/BAT0/state;
sensors
)"

