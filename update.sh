#!/bin/bash -e
# $File: update.sh
# $Date: Sat Feb 25 01:17:16 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

for i in *
do
	[ "$i" == 'list' -o "$i" == 'update.sh' ] || \
		rm -rvf "$i"
done

grep -v '^#' list | \
	while read src dst git
	do
		[ -z "$src" ] && continue
		[ -z "$src" ] && continue
		eval "src=$src"
		[ -z "$dst" ] && dst=$(basename $src)
		cp -av $src $dst
		[ -z "$git" ] || rm -rvf $dst/.git*
	done 

