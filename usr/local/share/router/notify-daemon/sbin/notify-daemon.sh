#!/bin/bash
### Bash notify daemon
### 30.01.2019 - 12.02.2019, 19.02.2019

# Where is my home?
home_dir='/usr/local/etc/notify-daemon'

# Import settings
. $home_dir/settings.rc

# Define log function
log()
{
	echo "`date '+%d.%m.%Y %H:%M:%S'` $PPID $@" >> $log_file 2>&1
}

# If you want journal
if [ "$1" = 'journal' ]; then
	. $home_dir/journal-manager.rc # Import journal manager

	[ "$2" = '' ] && echo 'Usage: journal list|del' && exit 1
	case $2 in
		'list')
			if [ "$3" = '' ];then
				echo 'Usage: journal list parser_name'
				echo; echo 'Available parsers:'
				[ "`ls $home_dir/journal-manager.rc.d/*.rc 2>/dev/null`" = '' ] && \
					echo ' ! No parsers defined' || \
					for i in $home_dir/journal-manager.rc.d/*.rc; do
						unset parser_name
						. $i
						echo $parser_name
					done
				exit 1
			fi
			journal_parse_database "$3"
		;;
		'del')
			[ "$3" = '' ] && echo 'Usage: journal del notify_id' && exit 1
			journal_del "$3"
		;;
	esac

	exit 0
fi

# If you want my home directory
if [ "$1" = 'print-home-dir' ]; then
	echo -n "$home_dir"
	exit 0
fi

# If you want standard init parameters
case $1 in
	'start')
		echo $0
		nohup $0 daemon > /dev/null 2>&1 &
		exit 0
	;;
	'stop')
		killall notify-daemon.sh > /dev/null 2>&1
		exit 0
	;;
	'status')
		procs=`ps -A | grep 'notify-daemon.' | wc -l`
		[ "$procs" -ge '3' ] && exit 0 || exit 1
	;;
esac

# If you want help
if [ "$1" = '--help' ]; then
	echo; echo ' Notify daemon'
	echo; echo ' Usage:'
	echo 'Start:   notify-daemon.sh daemon'
	echo 'Journal: notify-daemon.sh journal list [parser_name] | del [notify_id]'
	echo; echo 'Developer info at the bottom of this script'
	echo; exit 0
fi

# No "daemon" parameter, no start
if [ ! "$1" = 'daemon' ]; then
	echo 'No "daemon" parameter, no good, no start.'
	echo 'See "notify-daemon.sh --help"'
	exit 1
fi 

# Log script start
log 'main: Notify daemon started'


# Initialize loop numbering
$clear_environment && loop_indicator='1'

# Start main loop
while true; do
	# Check enabled
	if ! $enabled; then
		log 'main: Notify daemon disabled, exiting...'
		exit 0
	fi

	# Keep calm
	log ":: main: Loop #$loop_indicator started, sleeping..."
	sleep $check_every

	. $home_dir/settings.rc # Re-import settings
	. $home_dir/journal-manager.rc # Import journal manager

	. $home_dir/events.rc # Import events
	. $home_dir/critical-events.rc # Import critical events
	. $home_dir/sender.rc # Import sender

	log 'main: Checking critical events'
	for x in $critical_checklist; do
		if check_$x; then
			log "main: $x returned true, sending notify"
			send_notify_$x
			log "main: Doing critical action for $x"
			do_critical_$x
		fi
	done

	log 'main: Checking events'
	for i in $checklist; do
		if check_$i; then
			log "main: $i returned true, sending notify"
			send_notify_$i
		fi
	done

	# Calculate script life or restart if eol
	if $clear_environment; then
		if [ "$loop_indicator" -ge "$clear_environment_every" ]; then
			log 'main: End of life, restarting script...'
			exec $0 daemon
		else
			loop_indicator=$((loop_indicator+1))
		fi
	fi
done

log 'main: Error! Out of loop! Exiting...'
exit 1

===========================================
=  Dev details             Notify daemon  =
===========================================

This is quite a big invention, as for shell script.


Map:
|-main
||-settings.rc
||-journal-manager.rc (don't touch this!)
|||-journal-manager.rc.d/*.rc
|||-$journal_workspace/*
||-events.rc (don't touch this!)
|||-events.rc.d/*.rc
||-critical-events.rc (don't touch this!)
|||-critical-events.rc.d/*.rc
||-sender.rc (don't touch this!)
|||-sender.rc.d/*.rc
|||-sender.rc.d/journal.rc (don't touch this!)
||||-sender_config.rc.d/script_name.rc (hardcoded - see sender.rc.d/TEMPLATE)

Explanation:
 In settings.rc are essential variables.
In this you can disable/enable daemon, decrease/increase sleep time (used in line 102),
enable "garbage collector" (clear_environment=), set maximum number of loops in script life (clear_environment_every=),
and change paths to workspace and log file.
 Journal-manager manages notifications.
All notifications are stored in $journal_workspace.
 events.rc invokes all *.rc in events.rc.d for loop in line 111.
To create new event, copy TEMPLATE, rename it to your name and carefully edit.
 critical-events are normal events with shell commands.
 In sender are send methods (sms, mail, etc). Don't touch sender.rc.d/journal.rc!
If you want configuration file, create it in sender_config.rc.d with the same name,
and put variables in it.
 send_check_notify() in sender.rc checks $journal_log_file if notify was sended n hours back.
You can use this in sender.rc.d/*.rc with arguments "hours_back" "from" "importance" "message"; eg:
send_check_notify '24' "$1" "$2" "$3" && do something "$1" "$2" "$3"
and you can use this in send methods that are paid or you don't want to be spammed.

Enable/Disable:
For sender.rc.d/*.rc you can disable by changing NAME__enabled='true' to NAME__enabled='false' in sender_config.rc.d/NAME.rc
or by renaming NAME.rc to NAME.rc.disabled in sender.rc.d
For critical-events.rc.d and events.rc.d you can only rename NAME.rc to NAME.rc.disabled
Files in journal-manager.rc.d don't need disabling (see section below).

Journal:
journal-manager.rc doing (almost) all work.
It also needs sender.rc.d/journal.rc to register notifies (by send_by_journal() -> journal_add() functions).
Functions journal_parse_database and check_notify_exists (in journal-manager.rc) requires arguments in order: $from $importance $message.
These arguments are from $journal_workspace/*.
journal_parse_database() grabs journal-manager.rc.d/*.rc and looking for parser_name.
It's called from main at line 36 and requires $parser_name.
Function journal_add calculates new notify $id and save parameters to journal's workspace.
Arguments in order $id $from $importance $message are from sender.rc.d/journal.rc
Function journal_del is called from main at line 40 and requires only $id.

Templates:
Pretty name -> Name displayed in eg web page
NAME -> all NAME strings must be the same and unique (cpu.rc script are NAME renamed to cpu, cputemp are NAME ren. to cputemp)
CONDITION -> you can rewrite this, but it must decide if situation is ok (send notify -> return 0; no action -> return 1) 

Debugging:
All bash errors are printed in stdout and stderr.
You can also debug by echo 'here i am' and $log_file.
Remember to kill daemon, remove log (log_file path in settings.rc) and journal workspace directory (journal_workspace in settings.rc).

Attention!
The script is sensitive for errors.
Don't touch journal-manager.rc, events.rc, events.rc.d/journal.rc, critical-events.rc and sender.rc.
Debug after any change.
If you want to make big changes, copy script and configuration to test pool and change paths in settings.
