#!/bin/bash -e

if [[ `whoami` != "root" ]];
then
	echo "You must be root to mount usb disk."
	exit -1
fi

if [[ "foo${1}" == "foo" ]];
then
	echo "Usage: $0 <device file> [<target directory>]"
	exit -1
fi

if [[ "foo${2}" == "foo" ]];
then
	target="/mnt/tmp"
else
	target=$2
fi

mount -o iocharset=utf8,dmask=022,fmask=133,uid=1000,gid=1000  -t ntfs-3g $1 $target
