#!/bin/bash
cd /home
(sudo tar cvf /mnt/tmp/jiakai-home-$(date +%Y-%m-%d).tar jiakai \
	--exclude=jiakai/downloads \
	--exclude=jiakai/.VirtualBox --exclude=jiakai/VirtualBox_data \
	--exclude=jiakai/BOINC  \
	--exclude=jiakai/.config/chromium \
	--exclude=jiakai/.mozilla \
	--exclude=jiakai/.cache \
	--exclude=jiakai/.thumbnails \
	--exclude=jiakai/tar-log; echo "Exit code: $?") 2>&1 | tee /home/jiakai/tar-log
