#!/bin/bash
### acpid choice by power button click
### 06.02.2019, 17.02.2019

# Settings #############################
beep='beep'
beep_length='60'
beep_frequency='440'
sleep_length='0.1'
wait_for_others='2'

# Started - notify #####################

$beep -f $beep_frequency -l $beep_length

# Make indicators ######################

# check 2nd click
if [ -e /tmp/.acpid-choice-first ]; then
	# I was here
	touch /tmp/.acpid-choice-second
	exit 0
fi

# check 1st click
touch /tmp/.acpid-choice-first

########################################
# Cmds below can exec only 1st instance
########################################

# Functions ############################

first_click()
{
	# Execute rtcwake suspend after power button click
	## acpid-patch parameter not needed anymore
	/path/to/your/suspend/command
}
second_click()
{
	# Shutdown
	/sbin/halt
}

# Wait for other instances #############

sleep $wait_for_others

# Check ################################

if [ -e /tmp/.acpid-choice-second ]; then
	# Notify - 3x
	$beep -f $beep_frequency -l $beep_length; sleep $sleep_length; $beep -f $beep_frequency -l $beep_length; sleep $sleep_length; $beep -f $beep_frequency -l $beep_length

	# Remove indicator
	rm /tmp/.acpid-choice-second
	rm /tmp/.acpid-choice-first

	# Do 2nd click function
	second_click

	# Quit now
	exit 0
fi

# No 2nd click, notify, clean and do 1st click function, first beep 2x
$beep -f $beep_frequency -l $beep_length; sleep $sleep_length
	$beep -f $beep_frequency -l $beep_length
rm /tmp/.acpid-choice-first
first_click

########################################

# Quit normally
exit 0

########################################
########################################
Expansion:
add this at line 17:
	# check 5th click
	if [ -e /tmp/.acpid-choice-fifth ]; then
		# I was here
		touch /tmp/.acpid-choice-fifth
		exit 0
	fi
	# check 4th click
	if [ -e /tmp/.acpid-choice-fourth ]; then
		# I was here
		touch /tmp/.acpid-choice-fourth
		exit 0
	fi
	# check 3rd click
	if [ -e /tmp/.acpid-choice-third ]; then
		# I was here
		touch /tmp/.acpid-choice-third
		exit 0
	fi
add third_click, fourth_click, fifth_click etc functions at line 33,
add at line 51 in this scheme:
	if [ -e /tmp/.acpid-choice-fifth ]; then
		# Notify - 5x
		$beep -f $beep_frequency -l $beep_length; sleep $sleep_length; $beep -f $beep_frequency -l $beep_length; sleep $sleep_length; $beep -f $beep_frequency -l $beep_length; sleep $sleep_length; $beep -f $beep_frequency -l $beep_length; sleep $sleep_length; $beep -f $beep_frequency -l $beep_length

		# Remove indicator
		rm /tmp/.acpid-choice-fifth
		rm /tmp/.acpid-choice-fourth
		rm /tmp/.acpid-choice-third
		rm /tmp/.acpid-choice-second
		rm /tmp/.acpid-choice-first

		# Do 5th click function
		fifth_click

		# Quit now
		exit 0
	fi
	if [ -e /tmp/.acpid-choice-fourth ]; then
		# Notify - 5x
		$beep -f $beep_frequency -l $beep_length; sleep $sleep_length; $beep -f $beep_frequency -l $beep_length; sleep $sleep_length; $beep -f $beep_frequency -l $beep_length; sleep $sleep_length; $beep -f $beep_frequency -l $beep_length; sleep $sleep_length; $beep -f $beep_frequency -l $beep_length

		# Remove indicator
		rm /tmp/.acpid-choice-fourth
		rm /tmp/.acpid-choice-third
		rm /tmp/.acpid-choice-second
		rm /tmp/.acpid-choice-first

		# Do 4th click function
		fourth_click

		# Quit now
		exit 0
	fi
	if [ -e /tmp/.acpid-choice-third ]; then
		# Notify - 4x
		$beep -f $beep_frequency -l $beep_length; sleep $sleep_length; $beep -f $beep_frequency -l $beep_length; sleep $sleep_length; $beep -f $beep_frequency -l $beep_length; sleep $sleep_length; $beep -f $beep_frequency -l $beep_length

		# Remove indicator
		rm /tmp/.acpid-choice-third
		rm /tmp/.acpid-choice-second
		rm /tmp/.acpid-choice-first

		# Do 3rd click function
		third_click

		# Quit now
		exit 0
	fi
