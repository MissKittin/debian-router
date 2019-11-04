#!/bin/sh
# Auto perm ban
# 10.08.2019
CONFIG='/usr/local/etc/permanently-banned.rc'
iptables='iptables'
ip6tables='ip6tables'
ebtables='ebtables'

print_S1()
{
	echo -n "$1"
}

if [ "$1" = 'enable' ]; then
	cat $CONFIG | while read line; do
		if [ ! $(print_S1 $line) = '#' ]; then
			# WAN & Router IPv4
			$iptables -I INPUT -m mac --mac-source $(print_S1 $line) -j REJECT
			$iptables -I FORWARD -m mac --mac-source $(print_S1 $line) -j REJECT
			# WAN & Router IPv6
			$ip6tables -I INPUT -m mac --mac-source $(print_S1 $line) -j REJECT
			$ip6tables -I FORWARD -m mac --mac-source $(print_S1 $line) -j REJECT
			# LAN
			$ebtables -A FORWARD -s $(print_S1 $line) -j DROP
		fi
	done
	exit 0
fi

if [ "$1" = 'disable' ]; then
	cat $CONFIG | while read line; do
		if [ ! $(print_S1 $line) = '#' ]; then
			# WAN & Router IPv4
			$iptables -D INPUT -m mac --mac-source $(print_S1 $line) -j REJECT
			$iptables -D FORWARD -m mac --mac-source $(print_S1 $line) -j REJECT
			# WAN & Router IPv6
			$ip6tables -D INPUT -m mac --mac-source $(print_S1 $line) -j REJECT
			$ip6tables -D FORWARD -m mac --mac-source $(print_S1 $line) -j REJECT
			# LAN
			$ebtables -D FORWARD -s $(print_S1 $line) -j DROP
		fi
	done
	exit 0
fi

echo 'Auto perm ban'
echo " Config file: $CONFIG"
echo " usage: $0 enable | disable"

exit 0
