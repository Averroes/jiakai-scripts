#!/bin/bash -e
# $File: chinanet_tool.sh
# $Date: Mon Apr 18 17:02:56 2011 +0800

TMPDIR='/tmp/chinanet'
DEVICE='wlan0'
USERNAME=cdqz
PASSWORD=cdqz1t

if [ -z "$1" ]
then
	$0 connect && $0 login
	exit
fi

function show_help()
{
	cat <<EOF
Usage: $0 [operation]
operation=connect|login|logout|time|help
connect:
	configure wlan0 to connect to ChinaNet (root permission required)
login:
	request login with user "cdqz"
logout:
	request logout
time:
	show remaining time
help:
	show this help message
If operation is omitted, this script will try to connect and then login
EOF
}

mkdir -pv $TMPDIR

# check login status
# optional argument:
#	$1	--	path of the web page
#			if supplied, the file will be used
#			otherwise it will be downloaded to $TMPDIR/index
function check_login()
{
	if [ -n "$1" -a -f "$1" ]
	then
		fname=$1
	else
		fname="$TMPDIR/index"
		wget "http://wlan.ct10000.com:8080/hwssp/index.do" -O  $fname \
			--keep-session-cookie --save-cookies=$TMPDIR/cookie -nv
	fi

	if grep '登录成功' $fname >/dev/null
	then
		echo "Time: $(grep 'leaveTime' "$fname" | sed 's/[^0-9]//g') seconds."
		return 0
	fi
	return 1
}

case $1 in
	connect)
		iwconfig $DEVICE | grep "ChinaNet" > /dev/null && exit
		if [ "$UID" != "0" ]
		then
			echo "Root permission required"
			exit -1
		fi
		[ -f "/var/run/dhcpcd-$DEVICE.pid" ] && kill $(< "/var/run/dhcpcd-$DEVICE.pid") && sleep 1
		iwconfig $DEVICE essid "ChinaNet"
		dhcpcd $DEVICE
		;;
	login)
		check_login && exit
		wget "http://wlan.ct10000.com:8080/hwssp/mlogin.do" -O $TMPDIR/loginresult \
			--post-data="action=login&loginType=1&password=${PASSWORD}&phoneNumber=${USERNAME}&suffix=sc&x=0&y=0" -nv
		if grep_result=$(grep "style=" "$TMPDIR/loginresult" -n)
		then
			echo 'Failed to log in.'
			line_num=$(( $(echo "$grep_result" | sed 's/^\([0-9]*\)[^0-9].*/\1/g') + 1 ))
			nline=$(wc -l "$TMPDIR/loginresult" | sed 's/[^0-9]*//g')
			while [ $line_num -le $nline ]
			do
				line_val=$(head -n "$line_num" "$TMPDIR/loginresult" | tail -n 1)
				[ $(expr match "$line_val" '.*</div>.*') -gt 0 ] && break
				echo "$line_val"
				let line_num=$line_num+1
			done
			exit 1
		fi
		if [ $? -eq 0 ] && check_login 
		then
			echo 'Login successfully.'
		else
			echo "Unable to retrieve your login status，please see $TMPDIR/loginresult for more details or try command '$0 time'"
		fi
		;;
	logout)
		wget "http://wlan.ct10000.com:8080/hwssp/mlogout.do" -O /dev/null -nv
		echo "Logged out."
		;;
	time)
		check_login || echo 'You have not logged in yet.'
		;;
	help)
		show_help
		;;
	*)
		echo "Unknown Operation: $@"
		show_help
		;;
esac
