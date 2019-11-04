#!/bin/sh
# DDNS by hosts for isc-dhcp-server -> dnsmasq
# 05.02.2019

ddns_hosts_file='/tmp/.ddns-hosts'
hosts_file='/tmp/.dns-hosts'

# $1 - commit/release, $2 - IP, $3 - MAC, $4 - hostname
case $1 in
	'commit')
		# Ignore none or no hostname
		[ "$4" = 'none' ] && exit 0
		[ "$4" = '' ] && exit 0

		# Check if exists in hosts
		cat $hosts_file | grep "$4" > /dev/null 2>&1 && exit 0
		cat $ddns_hosts_file | grep "$4" > /dev/null 2>&1 && exit 0

		# Commit
		#echo "${2}\t${4}.lan" >> $hosts_file
		echo "${2}\t${4}" >> $ddns_hosts_file

		# Flush dnsmasq's cache
		killall -s SIGHUP dnsmasq
	;;
esac

exit 0
