#!/bin/bash -e
if [[ `whoami` != 'root' ]]
then
	echo "You must be root to run me"
	exit
fi

mysqld_safe -u mysql &

sleep 2
php-fpm
mkdir /tmp/nginx
nginx
echo "Remember to start orzoj-server !"

#mkdir /tmp/data
#cd /home/jiakai/programming/orzoj/old/linux_judge
#./orzoj conf


