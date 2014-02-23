#!/bin/bash
for i in $(seq 0 3)
do
	echo "conservative" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor
done
for i in $(seq 0 3)
do
	cat /sys/devices/system/cpu/cpu$i/cpufreq/cpuinfo_cur_freq
done
