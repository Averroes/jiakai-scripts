#!/bin/bash
if [ -z "$1" ]
then
	echo "Usage: $0 <host>"
	exit 1
fi
TARGET="$1"
MAX_TRIES=3

function get_status()
{
	cnt=0
	while [ $cnt -le $MAX_TRIES ]
	do
		ping -c 1 "$TARGET"  > /dev/null && return 0
		let cnt=$cnt+1
	done
	return 1
}

function echo_time()
{
	date "+[%s] (%Y-%m-%d %H:%M:%S)"
}

function echo_status()
{
	if [ "$prev_status" != "$1" ]
	then
		if (exit $1)
		then
			echo "$(echo_time): network is up"
		else
			echo "$(echo_time): network is down"
		fi
		prev_status=$1
	fi
}

while true
do
	get_status
	echo_status $?
done

