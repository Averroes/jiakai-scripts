#!/bin/bash -e
# $File: startx.sh
# $Date: Sat May 05 09:00:54 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

(
cd $HOME
X :0 &
export DISPLAY=:0
sleep 3

/usr/bin/dbus-launch --exit-with-session startfluxbox
) 2>&1 | tee /tmp/xinitrc_log

