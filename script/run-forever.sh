#!/bin/bash
# $File: run-forever.sh
# $Date: Fri Feb 10 09:21:26 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

while true
do
	"$@"
	sleep 1
done

