#!/bin/bash -e
# $File: vdisk.weibo-downloader.sh
# $Date: Tue Aug 21 20:51:41 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

PYTHON=python2
[ -z "$COOKIE" ] && COOKIE=cookie.txt

if [ -z "$1" ]
then
	echo "usage: $0 <addr>"
	exit -1
fi

if [ ! -f "$COOKIE" ]
then
	echo "please supply the cookie file"
	exit -1
fi

echo -n "Retrieving fid ... "
fid=$(wget "$1" -o /dev/null -O - | \
	grep -o '"fid":"[0-9]*"' | uniq | grep -o '[0-9]*')
echo "fid=$fid"

tmp=$(mktemp)
echo "Resolving address ..."
wget -o /dev/null -O $tmp --no-cookies --header "Cookie: $(cat $COOKIE)" \
	"http://vdisk.weibo.com/share/ajaxFileinfo?fid=${fid}&dl=true"

$PYTHON << _EOF_
import json
import urllib2
with open('$tmp') as f:
	data = json.loads(f.read())
url = data['s3_url'].encode('utf-8')
fn = urllib2.unquote(url.split('&')[-1].split('=', 1)[1])
with open('$tmp', 'w') as f:
	f.write(' '.join((data['md5'].encode('utf-8'), url, fn)) + '\n')
_EOF_

read md5 url fn < $tmp

wget -c --no-cookies --header "Cookie: $(cat $COOKIE)" -O "$fn" \
	-o "/tmp/log.vdisk.wget.$(basename $1)" "$url" 
echo "$md5 $fn" | md5sum --check || mv $fn /tmp/bad.$fn

