#!/bin/bash -e
NCPU=4

for i in $(seq 0 $(($NCPU-1)))
do
	cat /sys/devices/system/cpu/cpu$i/cpufreq/cpuinfo_cur_freq
done

