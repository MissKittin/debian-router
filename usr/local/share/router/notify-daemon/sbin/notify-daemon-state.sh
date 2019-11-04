#!/bin/bash
# Notify daemon's state analyzer

# parse functions
print_S1()
{
	echo -n "$1"
}

# get home directory
home_dir=`notify-daemon.sh print-home-dir`

# Choose output form
if [ "$1" = 'www' ]; then
	# Get events
	echo '<h3>Events:</h3>'; echo '<table>'
	[ "`ls $home_dir/events.rc.d/*.rc 2>/dev/null`" = '' ] || for i in $home_dir/events.rc.d/*.rc; do
		unset event_name
		. $i
		echo '<tr><td>'"$event_name"'</td><td><span style="color: #009900;">Enabled</span></td><td><a href="'"$2"'?action=disable&type=event&name='"${i##*/}"'" style="text-decoration: none; color: #0000ff">Disable</a></td></tr>'
	done
	[ "`ls $home_dir/events.rc.d/*.rc.disabled 2>/dev/null`" = '' ] || for i in $home_dir/events.rc.d/*.rc.disabled; do
		unset event_name
		. $i
		echo '<tr><td>'"$event_name"'</td><td><span style="color: #990000;">Disabled</span></td><td><a href="'"$2"'?action=enable&type=event&name='"${i##*/}"'" style="text-decoration: none; color: #0000ff">Enable</a></td></tr>'
	done
	echo '</table>'

	# Get critical events
	echo '<h3>Critical events:</h3>'; echo '<table>'
	[ "`ls $home_dir/critical-events.rc.d/*.rc 2>/dev/null`" = '' ] || for i in $home_dir/critical-events.rc.d/*.rc; do
		unset critical_event_name
		. $i
		echo '<tr><td>'"$critical_event_name"'</td><td><span style="color: #009900;">Enabled</span></td><td><a href="'"$2"'?action=disable&type=critical-event&name='"${i##*/}"'" style="text-decoration: none; color: #0000ff">Disable</a></td></tr>'
	done
	[ "`ls $home_dir/critical-events.rc.d/*.rc.disabled 2>/dev/null`" = '' ] || for i in $home_dir/critical-events.rc.d/*.rc.disabled; do
		unset critical_event_name
		. $i
		echo '<tr><td>'"$critical_event_name"'</td><td><span style="color: #990000;">Disabled</span></td><td><a href="'"$2"'?action=enable&type=critical-event&name='"${i##*/}"'" style="text-decoration: none; color: #0000ff">Enable</a></td></tr>'
	done
	echo '</table>'

	# Get senders
	echo '<h3>Senders:</h3>'; echo '<table>'
	[ "`ls $home_dir/sender.rc.d/*.rc 2>/dev/null`" = '' ] || for i in $home_dir/sender.rc.d/*.rc; do
		unset send_method_name
		search_enabled=false

		. $i

		# variable analyze
		if set | grep '__enabled=' > /dev/null 2>&1; then
			search_enabled=true
			name_search=`set | grep '__enabled='`
			name="\$${name_search%__*}__enabled"
			value=`eval echo -n "$name"`
		fi

		if [ "$value" = '' ]; then
			echo "<tr><td>$send_method_name</td><td></td><td></td></tr>"
		elif $value; then
			echo '<tr><td>'"$send_method_name"'</td><td><span style="color: #009900;">Enabled</span></td><td><a href="'"$2"'?action=disable&type=sender-manually&name='"${i##*/}"'" style="text-decoration: none; color: #0000ff">Disable</a></td></tr>'
		else
			echo '<tr><td>'"$send_method_name"'</td><td><span style="color: #990000;">Disabled</span></td><td><a href="'"$2"'?action=enable&type=sender-config&name='"${i##*/}"'" style="text-decoration: none; color: #0000ff">Enable</a></td></tr>'
		fi

		$search_enabled && unset ${name_search%=*}
		$search_enabled && unset name_search
	done
	[ "`ls $home_dir/sender.rc.d/*.rc.disabled 2>/dev/null`" = '' ] || for i in $home_dir/sender.rc.d/*.rc.disabled; do
		unset send_method_name
		. $i
		echo '<tr><td>'"$send_method_name"'</td><td><span style="color: #990000;">Disabled</span></td><td><a href="'"$2"'?action=enable&type=sender-manually&name='"${i##*/}"'" style="text-decoration: none; color: #0000ff">Enable</a></td></tr>'
	done
	echo '</table>'
else
	# Get events
	echo 'Events:'
	[ "`ls $home_dir/events.rc.d/*.rc 2>/dev/null`" = '' ] || for i in $home_dir/events.rc.d/*.rc; do
		unset event_name
		. $i
		echo "$event_name [enabled]"
	done
	[ "`ls $home_dir/events.rc.d/*.rc.disabled 2>/dev/null`" = '' ] || for i in $home_dir/events.rc.d/*.rc.disabled; do
		unset event_name
		. $i
		echo "$event_name [disabled]"
	done

	# Get critical events
	echo; echo 'Critical events:'
	[ "`ls $home_dir/critical-events.rc.d/*.rc 2>/dev/null`" = '' ] || for i in $home_dir/critical-events.rc.d/*.rc; do
		unset critical_event_name
		. $i
		echo "$critical_event_name [enabled]"
	done
	[ "`ls $home_dir/critical-events.rc.d/*.rc.disabled 2>/dev/null`" = '' ] || for i in $home_dir/critical-events.rc.d/*.rc.disabled; do
		unset critical_event_name
		. $i
		echo "$critical_event_name [disabled]"
	done

	# Get senders
	echo; echo 'Senders:'
	[ "`ls $home_dir/sender.rc.d/*.rc 2>/dev/null`" = '' ] || for i in $home_dir/sender.rc.d/*.rc; do
		unset send_method_name
		search_enabled=false

		. $i

		# variable analyze
		if set | grep '__enabled=' > /dev/null 2>&1; then
			search_enabled=true
			name_search=`set | grep '__enabled='`
			name="\$${name_search%__*}__enabled"
			value=`eval echo -n "$name"`
		fi

		if [ "$value" = '' ]; then
			echo "$send_method_name"
		elif $value; then
			echo "$send_method_name [enabled]"
		else
			echo "$send_method_name [disabled]"
		fi

		$search_enabled && unset ${name_search%=*}
		$search_enabled && unset name_search
	done
	[ "`ls $home_dir/sender.rc.d/*.rc.disabled 2>/dev/null`" = '' ] || for i in $home_dir/sender.rc.d/*.rc.disabled; do
		unset send_method_name
		. $i
		echo "$send_method_name [disabled]"
	done

	# Get parsers
	echo; echo 'Notifications'"'"' parsers:'
	[ "`ls $home_dir/journal-manager.rc.d/*.rc 2>/dev/null`" = '' ] || for i in $home_dir/journal-manager.rc.d/*.rc; do
		unset parser_name
		. $i
		echo $parser_name
	done
fi

exit 0