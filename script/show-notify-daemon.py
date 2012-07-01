#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# $File: show-notify-daemon.py
# $Date: Fri Feb 10 09:23:42 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

import pynotify, sys

if len(sys.argv) != 4:
    sys.exit("usage: {0} <pipe file path> <default title> <default timeout>" . format(sys.argv[0]))


if not pynotify.init('show-notify-daemon'):
    sys.exit('initialization failed')
obj = pynotify.Notification(sys.argv[2], None)
obj.set_timeout(int(sys.argv[3]))
while True:
    with open(sys.argv[1]) as f:
        val = f.read()
    obj.update(sys.argv[2], val)
    obj.show()

