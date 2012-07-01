#!/bin/sh -e


SOURCE=$1
TARGET=$2

if [[ "foo$SOURCE" == "foo" || "foo$TARGET" == "foo" ]];
then
	echo "Usage: $0 source dest"
	exit 0
fi


if [[ "foo$CP" == "foo" ]];
then
	CP="cp"
fi

$CP "$SOURCE" "$TARGET" &
CPID=$!

function isalive()
{
	out=`ps -p $1 2> /dev/null`
	return $?
}

PREV_TIIZE=0

while [ 1 ];
do
	SSIZE=`/bin/ls -l $SOURCE | gawk "{print \\\$5}"`
	if [ -f $TARGET ];
	then
		TSIZE=`/bin/ls -l $TARGET | gawk "{print \\\$5}"`
	else
		TSIZE="0"
	fi
	PERCENT=`python -c "print \"%.2f\" % (100*$TSIZE/$SSIZE)"`
	RATE=`python -c "print 63*$TSIZE/$SSIZE"`
	SPEED=`python -c "print ($TSIZE - $PREV_TIIZE)/1024/1024"`
	PREV_TIIZE=$TSIZE
	BLUE="\\033[3;44m"
	NORMAIL="\\033[0;39m"

	BAR=$BLUE
	i=0
	while [ $i -le 62 ];
	do
		if [[ $i == $RATE ]];
		then
			BAR="$BAR\\033[7;39m"
		fi
		BAR="$BAR "
		let i=$i+1
	done
	BAR=$BAR$NORMAIL
	echo -en "\r$BAR     ${PERCENT}%  ${SPEED} MB/S"
	if ! isalive "$CPID";
	then
		echo -en "\n";
		exit;
	fi
	sleep 1
done
