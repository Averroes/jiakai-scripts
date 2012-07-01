#!/bin/bash -e
# $File: auto_cpu_freq.sh
# $Date: Fri Dec 31 20:20:16 2010 +0800
# $Author: jiakai <jia.kai66@gmail.com>
# 
# Change CPU  frequency according to temperature 
#

[ "x$MIN_TEMP" == "x" ] && MIN_TEMP="60"
[ "x$MAX_TEMP" == "x" ] && MAX_TEMP="75"
[ "x$REFRESH_INTERVAL" == "x" ] && REFRESH_INTERVAL="1.5"

[ "$UID" == "0" ] || (echo "you must be root to run me!" && exit)

CPUFREQ_FILE='/sys/devices/system/cpu/cpu%d/cpufreq/%s'

while [ 1 ]
do
	temp=0
	for i in $(sensors | awk '/Core *[0-9]*: *\+/ {print $3, " " }')
	do
		core_temp=$(echo $i | sed -e 's/^[^0-9]\([0-9]*\)\..*$/\1/g')
		[ $core_temp -gt $temp ] && temp=$core_temp
	done

	[ $temp -lt $MIN_TEMP ] && cur_mode="performance"
	[ $temp -gt $MAX_TEMP ] && cur_mode="powersave"

	if [ "x$cur_mode" != "x$prev_mode" ]
	then
		date
		prev_mode=$cur_mode
		core_num=0
		while [ 1 ]
		do
			governor_file=$(printf $CPUFREQ_FILE $core_num 'scaling_governor')
			[ -f $governor_file ] || break
			echo $cur_mode > $governor_file
			let core_num=$core_num+1
		done

		echo "Governor changed to $cur_mode, CPU frequency:"
		core_num=0
		while [ 1 ]
		do
			freq_file=$(printf $CPUFREQ_FILE $core_num 'cpuinfo_cur_freq')
			[ -f $freq_file ] || break
			cat $freq_file
			let core_num=$core_num+1
		done
	fi

	sleep $REFRESH_INTERVAL
done

