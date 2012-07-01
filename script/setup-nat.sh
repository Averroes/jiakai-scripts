#!/bin/bash -e

iptables --flush           		
iptables --table nat --flush

# delete all chains that are not in default filter and nat table, if any
iptables --delete-chain     
iptables --table nat --delete-chain

if [ "$1" == "--clear" ]
then
	echo 0 > /proc/sys/net/ipv4/ip_forward
	echo "all chains deleted"
	exit
fi

if [ -z "$1" -o -z "$2" ]
then
	echo "Usage: $0 [<in> <out> (NAT from in to out)] | [--clear]"
	exit
fi

IF_IN=$1
IF_OUT=$2

# Set up IP FORWARDing and Masquerading (NAT)
iptables --table nat --append POSTROUTING --out-interface $IF_OUT -j MASQUERADE
iptables -A FORWARD -i $IF_IN -o $IF_OUT -j ACCEPT

#enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

