#!/bin/bash -e
username='jiakai'
passwd='wohb9Eil8k'
browser="firefox"
if [[ ! -r $1 ]]
then
	echo "Usage: $0 <source-file>"
	exit -1
fi

cookie_path="/tmp/oj-cookie.txt"
output_file="/tmp/output.html"
prog_path="/tmp/`basename $1`"

echo > $prog_path

pid=`echo $1 | sed -e 's/[^0-9]*//g'`
ext=`echo $1 | sed -e 's/.*\.//g'`
case $ext in
	"cpp")
		echo "#define STDIO" > $prog_path
		lang=0;;
	"c")
		echo "#define STDIO" > $prog_path
		lang=1;;
	"pas")
		lang=2;;
	*)
		echo "Unknown extention: $ext"
		exit -1
esac

site_addr='http://61.187.179.132:8080/JudgeOnline'
login_addr="$site_addr/login?action=login"
submit_addr="$site_addr/submit"
status_addr="$site_addr/status"

cat $1 >> $prog_path

phpcontent="
<?php
\$file = fopen(\"$prog_path\", \"r\");
\$str = fread(\$file, filesize(\"$prog_path\"));
echo urlencode(\$str);
fclose(\$file);
?>
"

wget "$login_addr" --keep-session-cookies --save-cookies $cookie_path \
	--post-data "user_id1=$username&password1=$passwd" -O $output_file

wget "$submit_addr" --load-cookies $cookie_path \
	--post-data "problem_id=$pid&language=$lang&source=`echo $phpcontent | php`" -O $output_file

rm $prog_path
$browser "$status_addr" &
