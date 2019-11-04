#!/bin/sh
# hosts generator for dnsmasq

# Where I am?
ETCDIR='/usr/local/etc'
HOSTSFILE='/tmp/.dns-hosts'
DDNS_HOSTSFILE='/tmp/.ddns-hosts'

# Clear file
echo -n '' > $HOSTSFILE

# Put all hosts files
for i in $ETCDIR/hosts.d/*; do
	cat $i >> $HOSTSFILE
done

# Bottom of file is for ddns
#echo '# DDNS entrys' >> $HOSTSFILE

# Prepare DDNS file
[ -e $DDNS_HOSTSFILE ] || echo '# DDNS database' > $DDNS_HOSTSFILE

# Run from dnsmasq-hosts-build
[ "$1" = 'dnsmasq-hosts-build' ] && exit 0

# Flush dnsmasq's cache
#echo
#[ "$1" = 'start' ] && /etc/init.d/dnsmasq start || /etc/init.d/dnsmasq restart
#echo
killall -s SIGHUP dnsmasq

exit 0