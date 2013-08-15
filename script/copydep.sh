#!/bin/bash
# $File: copydep.sh
# $Date: Sat Jul 13 00:06:11 2013 +0800
# $Author: jiakai <jia.kai66@gmail.com>

exe=$1
dest=$2

if [ -z "$exe" -o -z "$dest" ]
then
	echo "usage: $0 <executable> <dest dir>"
	exit -1
fi

for file in $(ldd $exe | cut -d' ' -f 3)
do
	mkdir -p $dest/$(dirname $file)
	cp -L $file $dest/$file
done

ld_linux=$(ldd $exe | grep 'ld-linux' | cut -f 2 | cut -d' ' -f 1)
mkdir -p $dest/$(dirname $ld_linux)
cp -L $ld_linux $dest/$ld_linux

