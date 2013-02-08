#!/bin/bash -e
# $File: show-sysinfo.sh
# $Date: Wed Jan 02 13:43:52 2013 +0800
# $Author: jiakai <jia.kai66@gmail.com>

notify-send "System Info" "$(
date; echo -e '\n'; 
acpi;
sensors
)"

