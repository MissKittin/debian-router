#!/bin/bash
# Remount all relatime filesystems with noatime,nodiratime options

remount()
{
	mount -o remount,noatime,nodiratime $3
}

mount | while read line; do
	echo $line | grep "relatime" > /dev/null 2>&1 && \
		remount $line
done

exit 0
