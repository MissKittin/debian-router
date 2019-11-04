#!/bin/bash
### Firewall6 starter
### 29.01.2019, 18.02.2019
### 05.09.2019

# Where am I?
SETTINGS='/usr/local/etc/firewall6'

# Where is iptables
iptables='ip6tables'

# Print settings dir
if [ "$1" = 'where-are-you' ]; then
	echo -n "$SETTINGS"
	exit 0
fi

# Get firewall status
if [ "$1" = 'status' ]; then
	parse_firewall_line()
	{
		[ "$1" = '' ] && return
		[ "$1" = '#' ] && return
		[[ ${1:0:1} == '#' ]] && return

		[ "$2" = '-A' ] && return
		[ "$3" = 'nat' ] && return

		if [ "$2" = '-P' ]; then
			case $3 in
				'INPUT')
					[ "$INPUT_POLICY" = "$4" ] || touch /tmp/.firewall_not_loaded
				;;
				'OUTPUT')
					[ "$OUTPUT_POLICY" = "$4" ] || touch /tmp/.firewall_not_loaded
				;;
			esac
		fi
	}

	INPUT_POLICY=`$iptables --list | grep 'Chain' | grep 'INPUT' | awk '{print $4}' | tr -d ')'`
	OUTPUT_POLICY=`$iptables --list | grep 'Chain' | grep 'OUTPUT' | awk '{print $4}' | tr -d ')'`

	cat ${SETTINGS}/firewall.rc | while read line; do
		parse_firewall_line $line
	done

	if [ -e /tmp/.firewall_not_loaded ]; then
		rm /tmp/.firewall_not_loaded
		exit 1
	fi

	exit 0
fi

# Get routing status
#if [ "$1" = 'routing-status' ]; then
#	# Setup
#	. $SETTINGS/networks.rc
#
#	# Check nat
#	cat $SETTINGS/routing.rc | grep 'nat' | while read line; do
#		string=${line#*-o}
#		interface_variable=`echo -n $string | awk '{print $1}'`
#		interface=`eval echo -n "$interface_variable"`
#		if ! $iptables -t nat -L -n -v | grep "$interface" > /dev/null 2>&1; then
#			touch /tmp/.check-routing_routing-not-ok
#			break
#		fi
#	done
#	if [ -e /tmp/.check-routing_routing-not-ok ]; then
#		rm /tmp/.check-routing_routing-not-ok
#		exit 1
#	fi
#
#	# Now check forwarding
#	cat $SETTINGS/routing.rc | sed -e 's/$iptables //g' | grep -v 'nat' | while read line; do
#		if ! [[ ${line:0:1} == '#' ]]; then
#			eval_value=$(echo `eval echo $line`)
#			value=`echo -n "$value" | sed 's/-I/-A/g'`
#			if ! $iptables -S FORWARD | grep -- "$value" > /dev/null 2>&1; then
#				touch /tmp/.check-routing_routing-not-ok
#				break
#			fi
#		fi
#	done
#	if [ -e /tmp/.check-routing_routing-not-ok ]; then
#		rm /tmp/.check-routing_routing-not-ok
#		exit 1
#	fi
#
#	# If no error, exit success
#	exit 0
#fi

# Reset iptables
$iptables -P INPUT ACCEPT
$iptables -P FORWARD ACCEPT
$iptables -P OUTPUT ACCEPT
$iptables -t nat -F
$iptables -t mangle -F
$iptables -F
$iptables -X

# Loopback must be excluded
$iptables -A INPUT -i lo -j ACCEPT
$iptables -A OUTPUT -o lo -j ACCEPT
$iptables -A FORWARD -i lo -j ACCEPT

# Import network settings
. $SETTINGS/networks.rc

# Import firewall settings
. $SETTINGS/firewall.rc

# Import routing settings
. $SETTINGS/routing.rc

# Import forwarding settings
. $SETTINGS/forwarding.rc

# Import additional rules
[ "`ls $SETTINGS/additional_rules.d/*.rc 2>/dev/null`" = '' ] || for i in $SETTINGS/additional_rules.d/*.rc; do
	. $i
done

exit 0
