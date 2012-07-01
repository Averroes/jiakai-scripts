#!/bin/bash -e
# $File: update.sh
# $Date: Sun Jul 01 14:41:15 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

for i in *
do
	[ "$i" == 'list' -o "$i" == 'update.sh' ] || \
		rm -rf "$i"
done

grep -v '^#' list | \
	while read src dst git
	do
		[ -z "$src" ] && continue
		[ -z "$src" ] && continue
		if [ "$src" == "del:" ]
		then
			rm -rf $dst
		else
			eval "src=$src"
			[ -z "$dst" ] && dst=$(basename $src)
			cp -a $src $dst
			[ -z "$git" ] || rm -rf $dst/.git*
		fi
	done 


git add -A
git commit -a
