#!/bin/bash -e
if [[ `whoami` != "root" ]];
then
	echo "You must be root to mount the camera."
	exit -1
fi
modprobe fuse

if [[ "foo${1}" == "foo" ]];
then
	target="/mnt/tmp"
else
	target=$1
fi

gphotofs "$target" -o uid=1000,gid=1000,allow_other
