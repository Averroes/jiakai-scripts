#!/bin/bash -e
# $File: change-volume.sh
# $Date: Sat Jun 30 23:32:02 2012 +0800
if [ -z "$1"  -o \( "$1" != "raise" -a "$1" != "lower" \) ]
then
	echo "Usage: $0 <raise|lower>"
	exit -1
fi

if [ "$1" = "raise" ]
then
	cmd="2%+"
else
	cmd="2%-"
fi

amixer -q set PCM $cmd unmute
(echo "PCM volume:"; amixer sget PCM | \
	awk '/\[[0-9]*%\]/ {printf "%s %-8s %s\n", $1, $2, $5}') | \
	~/script/send-notify.sh

