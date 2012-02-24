#!/bin/bash -e
# $File: update.sh
# $Date: Sat Feb 25 00:36:40 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

while read src dst
do
	eval "src=$src"
	[ -z "$dst" ] && dst=$(basename $src)
	if [ -f "$src" ]
	then
		cp -f "$src" "$dst"
	else
		[ -d "$dst" ] || mkdir $dst
		(mount | grep $(realpath $dst) > /dev/null) || \
			sudo mount --bind "$src" "$dst"
	fi
done < list

