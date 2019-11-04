#!/bin/sh
# Add to /etc/resolv.conf and guard
# 22.09.2019
# Patch 03.10.2019

# Settings
home_dir='/usr/local/etc/resolvconf-updater.d'
resolvconf='/etc/resolv.conf'

[ -e $home_dir ] || exit 1
while true; do
	if [ ! "$(ls ${home_dir}/*.conf)" = '' ]; then
		touch /tmp/.resolvconf-updater__add_blank_line
		for i in ${home_dir}/*.conf; do
			cat $i | while read line; do
				if ! cat $resolvconf | grep "$line" > /dev/null 2>&1; then
					if [ -e /tmp/.resolvconf-updater__add_blank_line ]; then
						#echo '' >> $resolvconf
						rm /tmp/.resolvconf-updater__add_blank_line
					fi
					cat $resolvconf | grep '# Added by resolvconf-updater.sh' > /dev/null 2>&1 || echo '# Added by resolvconf-updater.sh' >> $resolvconf
					echo "$line" >> $resolvconf
				fi
			done
		done

		# Old version based by one config file
		#add_blank_line=true
		#cat $home_dir | while read line; do
		#	if ! cat $resolvconf | grep "$line" > /dev/null 2>&1; then
		#		if $add_blank_line; then
		#			echo '' >> $resolvconf
		#			add_blank_line=false
		#		fi
		#		cat $resolvconf | grep '# Added by resolvconf-updater.sh' > /dev/null 2>&1 || echo '# Added by resolvconf-updater.sh' >> $resolvconf
		#		echo "$line" >> $resolvconf
		#	fi
		#done
	fi
	sleep 30
done

exit 0
