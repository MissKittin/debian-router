#!/bin/sh
### Power button script injection for acpid
### /etc/acpi/powerbtn.sh
### 25.01.2019, 06.02.2019

# acpid twoclick patch
if [ -e /tmp/.powerbtn-acpid-patch ]; then
	rm /tmp/.powerbtn-acpid-patch
	exit 0
fi
touch /tmp/.powerbtn-acpid-patch

# delegate action to acpid-choice
/usr/local/sbin/acpid-choice.sh &

exit 0
