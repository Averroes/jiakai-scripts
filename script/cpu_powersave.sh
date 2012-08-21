#!/bin/bash -e
NCPU=4
for i in $(seq 0 $(($NCPU-1)))
do
	echo "powersave" > \
		/sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
done

for i in $(seq 0 $(($NCPU-1)))
do
	cat /sys/devices/system/cpu/cpu$i/cpufreq/cpuinfo_cur_freq
done

