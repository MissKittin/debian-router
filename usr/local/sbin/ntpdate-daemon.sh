#!/bin/sh
# Synchronize clock if connected to the internet
# 19.05.2019

PING_HOST='http://ftp.debian.org/'
while ! wget -q --tries=10 --timeout=20 --spider $PING_HOST; do
	sleep 5
done

ntpdate-debian > /tmp/.ntpdate.log 2>&1

exit 0
