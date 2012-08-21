#!/bin/bash -e
# $File: show-sysinfo.sh
# $Date: Wed Jul 11 16:33:55 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

notify-send "System Info" "$(
acpi;
sensors
)"

