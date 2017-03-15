#!/usr/bin/env bash

if [ $# != 1 ]; then
	echo "Usage: $0 <Guest-Name>"
	exit 1;
fi

arp -an | grep `sudo virsh dumpxml $1 | grep 'mac address' | cut -c 21-37` | cut -d '(' -f2|cut -d ')' -f1
