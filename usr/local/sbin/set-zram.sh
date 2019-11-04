#!/bin/bash
autoenable=true

enable_zram()
{
	cores=$(nproc --all)
	modprobe zram num_devices=$cores

	#swapoff -a

	totalmem=`free | grep -e "^Mem:" | awk '{print $2}'`
	mem=$(( ($totalmem / $cores)* 1024 ))

	core=0
	while [ $core -lt $cores ]; do
	  echo $mem > /sys/block/zram$core/disksize
	  mkswap /dev/zram$core
	  swapon -p 5 /dev/zram$core
	  let core=core+1
	done
}
disable_zram()
{
	cores=$(nproc --all)

	totalmem=`free | grep -e "^Mem:" | awk '{print $2}'`
	mem=$(( ($totalmem / $cores)* 1024 ))

	core=0
	while [ $core -lt $cores ]; do
	  swapoff  /dev/zram$core
	  let core=core+1
	done

}

case $1 in
	'enable')
		enable_zram
	;;
	'disable')
		disable_zram
	;;
	'autoenable')
		$autoenable && enable_zram
	;;
esac

exit 0
