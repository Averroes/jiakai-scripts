#!/bin/bash -e
LOGFILE="$HOME/$(basename "$0").log"
if [ "$UID" != "0" ]
then
	echo "you need to be root to run me"
	exit -1
fi

if [ -z "$1" ]
then
	echo "Usage: $0 <command name to be waited for>"
	exit -1
fi

while true
do
	if [ $(ps -C "$1" | wc -l) == "1" ]
	then
		echo "command $1 ended at $(date)" > $LOGFILE
		echo "process dump:" >> $LOGFILE
		ps aux >> $LOGFILE
		echo "shutting down"
		shutdown -h now
		exit
	fi
	sleep 5
done

