#!/bin/bash -e
cat << _EOF_
如果你有国外的SSH帐号，可以试试在ssh终端里面输入 ssh -qTfnN -D 7070 remote_server
然后在浏览器的代 理服务器中，socks代理中添加：
localhost 7070,其他为空，这是即可访问国外网站了。

ssh -qTfnN -D 7070 remotehost
All the added options are for a ssh session that’s used for tunneling.
-q :- be very quite, we are acting only as a tunnel.
-T :- Do not allocate a pseudo tty, we are only acting a tunnel.
-f :- move the ssh process to background, as we don’t want to interact with this ssh session directly.
-N :- Do not execute remote command.
-n :- redirect standard input to /dev/null.
In addition on a slow line you can gain performance by enabling compression with the -C option.

Note: set network.proxy.socks_remote_dns in firefox to true
_EOF_
echo "Password: phie5Gae"
ssh -TN -D 7070 jiakai@shell.cjb.net
#echo "Password: sshpwd1994"
#ssh -TN -D 7070 fqjsshuser@ssh3.fan-qiang.com
