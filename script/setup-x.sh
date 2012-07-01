#!/bin/bash -e
# $File: setup-x.sh
# $Date: Sat Jun 30 23:22:24 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

RUNNER=$HOME/script/run-forever.sh
fcitx &
xscreensaver -no-splash &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
#eval $(/usr/bin/gpg-agent --sh --no-use-standard-socket --daemon --default-cache-ttl 60 --max-cache-ttl 600)
#keynav &
#xpad &

DAEMON_PATH=/home/jiakai/script/show-notify-daemon.py
PIPE_PATH=/tmp/show-notify-pipe
mkfifo "$PIPE_PATH"
$RUNNER $DAEMON_PATH "$PIPE_PATH" "Notification" 500 &

$HOME/script/chg-brightness 2

#(cd ~/programming/projects/xabell && $RUNNER ./xabell bell.wav 100) &
