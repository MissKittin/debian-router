#!/bin/bash
### System autoupdate daemon for debian
### 25.01.2019, 29.01.2019

# Settings
check_every='12' # ~ hours
log_file='/tmp/.system_autoupdate.log'

# Get status
if [ "$1" = 'status' ]; then
	ps -Aef | grep -v 'grep' | grep -v 'status' | grep $0 > /dev/null 2>&1 && exit 0 || exit 1
fi

# Log function
log()
{
	echo ":: `date +'%d.%m.%Y %H:%M:%S'` $@" >> $log_file 2>&1
}

# Log start
log 'System autoupdate daemon started'

# Recalc hours to seconds
check_every_mins=$((check_every * 60))
check_every_secs=$((check_every_mins * 60))
log 'Sleep time recalculated, sleeping after first run...'

# Keep calm
sleep 120

# Start main loop
while true; do
	# Log
	log 'Loop started'

	# Check for internet
	PING_HOST='http://ftp.debian.org/'
	while ! wget -q --tries=10 --timeout=20 --spider $PING_HOST; do
		# Keep calm
		log 'No internet'
		sleep 10
	done

	# Do update
	log 'Updating...'
	apt-get update >> $log_file 2>&1
	[ "$?" = 0 ] && log 'Updated, checking...' || log 'Failed, checking...'

	# Read how many packages can be upgraded
	/usr/local/sbin/apt-check -h -c -f >> $log_file 2>&1

	# Clean
	log 'Cleaning...'
	apt-get clean

	# Sleep
	log 'OK, sleeping...'
	sleep $check_every_secs
done

log 'Error! Out of loop! Exiting...'
exit 1
