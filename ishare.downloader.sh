#!/bin/bash -e
# $File: ishare.downloader.sh
# $Date: Tue Aug 21 10:39:44 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

if [ -z "$1" ]
then
	echo "usage: $0 <addr>"
	exit -1
fi

tmp=$(mktemp)
echo "Retrieving original page ..."
wget -o /dev/null -O $tmp $1

fn=$(grep hiddenfile_title $tmp | iconv -f gb2312 -t utf-8 - | \
	sed -e 's/^.*value="\([^"]*\)".*$/\1/g')
addr="http://ishare.iask.sina.com.cn/$(grep download.php $tmp | \
	sed -e 's/^.*action="\([^"]*\)".*$/\1/g')"
rm -f $tmp

echo "wget $addr"
wget -c -o /tmp/log.ishare.wget.$(basename $1) -O "$fn" --referer "$1" "$addr"

echo "done"

