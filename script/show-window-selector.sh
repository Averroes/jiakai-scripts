#!/bin/bash -e
# $File: show-window-selector.sh
# $Date: Fri Jun 29 01:01:38 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>
list=()
TMP=$(mktemp)
wmctrl -lp | sort -k5 > $TMP
while read id desk pid user title
do
	list+=("$id" "$(ps -p $pid -o comm= || echo '<unknown>')" "$title")
done <$TMP
rm $TMP

ret=$(zenity --list \
	--column id --column "Command" --column "Title" --hide-column 1 \
	--text 'Select a window' --width 800 --height 600 \
	"${list[@]}")

exec wmctrl -ia $ret
