#!/bin/bash -e
# $File: xp.sh
# $Date: Sun Jul 01 00:48:05 2012 +0800
# $Author: jiakai <jia.kai66@gmail.com>

lsmod | grep kvm_intel > /dev/null || sudo modprobe kvm-intel
lsmod | grep virtio > /dev/null || sudo modprobe virtio

IMG=/mnt/ssd/jiakai/qemu/win-xp.img

qemu-system-x86_64  -enable-kvm \
	-drive file=$IMG \
	-m 1G \
	-net nic,model=rtl8139 \
	-net user
