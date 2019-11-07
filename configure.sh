#!/bin/sh
if [ ! "$(whoami)" = 'root' ]; then
	echo; echo '! You must run this with root (for chown)'; echo
	exit 1
fi
echo; echo ' debian router v1 - configure script'

echo; echo ' Cleaning...'
[ -e .git ] && rm -r -f .git
rm LICENSE
rm README.md
rm ./usr/local/etc/README.md
rm ./usr/local/sbin/README.md
rm ./usr/local/share/router/acpid-mods/README.md
rm ./usr/local/share/router/firewall/README.md
rm ./usr/local/share/router/localdns/README.md
rm ./usr/local/share/router/notify-daemon/README.md
rm ./usr/local/share/router/resolvconf-updater/README.md
rm ./usr/local/share/router/webadmin/README.md

echo; echo ' Changing uids and gids to root...'
chown root:root .
chown -R root:root ./*

echo; echo ' Chmodding...'
chmod 755 ./etc/rc.local
chmod 755 ./usr/local/etc/rc.local
chmod 750 ./usr/local/sbin/generate-ddns-hosts.sh
chmod 750 ./usr/local/sbin/ntpdate-daemon.sh
chmod 750 ./usr/local/sbin/remount-relatime.sh
chmod 750 ./usr/local/sbin/set-zram.sh
chmod 750 ./usr/local/sbin/system-autoupdate.sh
chmod 755 ./usr/local/share/router/acpid-mods/etc/acpi/powerbtn.sh
chmod 751 ./usr/local/share/router/acpid-mods/sbin
chmod 750 ./usr/local/share/router/acpid-mods/sbin/acpid-choice.sh
chmod 755 ./usr/local/share/router/firewall/etc/init.d/firewall
chmod 751 ./usr/local/share/router/firewall/sbin
chmod 750 ./usr/local/share/router/firewall/sbin/firewall.sh
chmod 750 ./usr/local/share/router/firewall/sbin/firewall6.sh
chmod 750 ./usr/local/share/router/firewall/sbin/permanently-banned.sh
chmod 755 ./usr/local/share/router/localdns/etc/init.d/dnsmasq-hosts-build
chmod 751 ./usr/local/share/router/localdns/sbin
chmod 750 ./usr/local/share/router/localdns/sbin/generate-dns-hosts.sh
chmod 751 ./usr/local/share/router/notify-daemon/sbin
chmod 750 ./usr/local/share/router/notify-daemon/sbin/notify-daemon-state.sh
chmod 755 ./usr/local/share/router/notify-daemon/sbin/notify-daemon.sh
chmod 751 ./usr/local/share/router/resolvconf-updater/sbin
chmod 750 ./usr/local/share/router/resolvconf-updater/sbin/resolvconf-updater.sh
chmod 755 ./usr/local/share/router/webadmin/bin/httpd_php-start.sh

echo; echo ' Preparing in local/etc:'; echo
cd ./usr/local/etc

echo ' - acpid-mods'
ln -s ../share/router/acpid-mods/etc/acpi ./acpi

echo ' - firewall and firewall6'
ln -s ../share/router/firewall/etc/firewall ./firewall
ln -s ../share/router/firewall/etc/firewall6 ./firewall6
ln -s ../share/router/firewall/etc/permanently-banned.rc ./permanently-banned.rc

echo ' - localdns'
ln -s ../share/router/localdns/etc/hosts.d ./hosts.d

echo ' - notify-daemon'
ln -s ../share/router/notify-daemon/etc/notify-daemon ./notify-daemon

echo ' - resolvconf-updater'
ln -s ../share/router/resolvconf-updater/etc/resolvconf-updater.d ./resolvconf-updater.d

echo; echo ' Preparing in local/etc/init.d:'; echo
mkdir init.d
cd init.d

echo ' - legacy bootordering'
touch .legacy-bootordering

echo ' - firewall & firewall6'
ln -s ../../share/router/firewall/etc/init.d/firewall ./firewall

echo ' - localdns'
ln -s ../../share/router/localdns/etc/init.d/dnsmasq-hosts-build ./dnsmasq-hosts-build

echo; echo ' Preparing in local/sbin:'; echo
cd ../../sbin

echo ' - acpid-mods'
ln -s ../share/router/acpid-mods/sbin/acpid-choice.sh ./acpid-choice.sh

echo ' - firewall & firewall6'
ln -s ../share/router/firewall/sbin/firewall.sh ./firewall.sh
ln -s ../share/router/firewall/sbin/firewall6.sh ./firewall6.sh
ln -s ../share/router/firewall/sbin/permanently-banned.sh ./permanently-banned.sh

echo ' - localdns'
ln -s ../share/router/localdns/sbin/generate-dns-hosts.sh ./generate-dns-hosts.sh

echo ' - notify-daemon'
ln -s ../share/router/notify-daemon/sbin/notify-daemon-state.sh ./notify-daemon-state.sh
ln -s ../share/router/notify-daemon/sbin/notify-daemon.sh ./notify-daemon.sh

echo ' - resolvconf-updater'
ln -s ../share/router/resolvconf-updater/sbin/resolvconf-updater.sh ./resolvconf-updater.sh

echo ' - webadmin'
ln -s ../share/router/webadmin/bin/httpd_php-start.sh ./httpd_php-start.sh

echo; echo ' Preparing in local/share:'; echo
cd ../share

echo ' - webadmin'
mkdir ./router/webadmin/www
ln -s ./router/webadmin/www ./www

echo; echo ' Preparing in etc:'; echo
cd ../../../etc

echo ' - apt.conf.d'
mkdir apt
cd apt
mkdir apt.conf.d
cd apt.conf.d
ln -s ../../../usr/local/etc/apt/apt.conf.d/99no-install-recommends
cd ../..

echo ' - acpid-mods'
mkdir acpi
cd acpi
ln -s ../../usr/local/etc/acpi/powerbtn.sh ./powerbtn.sh

echo ' - dnsmasq'
mkdir ../dnsmasq.d
cd ../dnsmasq.d
ln -s ../../usr/local/etc/dnsmasq/ddns.conf ./ddns.conf
ln -s ../../usr/local/etc/dnsmasq/dns.conf ./dns.conf
ln -s ../../usr/local/etc/dnsmasq/pxe.conf ./pxe.conf

echo ' - init.d'
mkdir ../init.d
cd ../init.d
ln -s ../../usr/local/etc/init.d/.legacy-bootordering ./.legacy-bootordering
ln -s ../../usr/local/etc/init.d/dnsmasq-hosts-build ./dc_dnsmasq-hosts-build
ln -s ../../usr/local/etc/init.d/firewall ./firewall

echo ' - php'
mkdir ../php ../php/7.0 ../php/7.0/cli ../php/7.0/cli/conf.d
cd ../php/7.0/cli/conf.d
ln -s ../../../../../usr/local/etc/php/7.0-cli-conf.d/97-zlib.ini ./97-zlib.ini
ln -s ../../../../../usr/local/etc/php/7.0-cli-conf.d/98-opcache.ini ./98-opcache.ini
ln -s ../../../../../usr/local/etc/php/7.0-cli-conf.d/99-security.ini ./99-security.ini

echo ' - sysctl'
mkdir ../../../../sysctl.d
cd ../../../../sysctl.d
ln -s ../../usr/local/etc/sysctl.d/ddos.conf ./ddos.conf
ln -s ../../usr/local/etc/sysctl.d/disable_watchdog.conf ./disable_watchdog.conf
ln -s ../../usr/local/etc/sysctl.d/ip_forward.conf ./ip_forward.conf
ln -s ../../usr/local/etc/sysctl.d/ipv6_forward.conf ./ipv6_forward.conf
ln -s ../../usr/local/etc/sysctl.d/sack_panic_workaround.rc ./sack_panic_workaround.rc
ln -s ../../usr/local/etc/sysctl.d/writeback_time.rc ./writeback_time.rc

echo ' - udev'
mkdir ../udev ../udev/rules.d
cd ../udev/rules.d
ln -s ../../../usr/local/etc/udev/hd_power_save.rules ./hd_power_save.rules
ln -s ../../../usr/local/etc/udev/pci_pm.rules ./pci_pm.rules

echo; echo ' Select items to install:'; echo
cd ../../..
mkdir ./out

echo -n '' > ./out/config.rc
while true; do
	echo -n ' [ 1/15] acpid-mods (y/n) '
	read acpid_mods
	if [ "$acpid_mods" = 'y' ]; then
		echo 'acpid_mods=y' >> ./out/config.rc
		break
	fi
	if [ "$acpid_mods" = 'n' ]; then
		rm -r -f ./etc/acpi
		rm ./usr/local/etc/acpi
		rm ./usr/local/sbin/acpid-choice.sh
		rm -r -f ./usr/local/share/router/acpid-mods
		echo 'acpid_mods=n' >> ./out/config.rc
		break
	fi
done
while true; do
	echo -n ' [ 2/15] firewall (y/n) '
	read firewall
	if [ "$firewall" = 'y' ]; then
		echo 'firewall=y' >> ./out/config.rc
		break
	fi
	if [ "$firewall" = 'n' ]; then
		rm ./etc/init.d/firewall
		rm ./usr/local/etc/firewall
		rm ./usr/local/etc/firewall6
		rm ./usr/local/etc/permanently-banned.rc
		rm ./usr/local/etc/init.d/firewall
		rm ./usr/local/sbin/firewall.sh
		rm ./usr/local/sbin/firewall6.sh
		rm ./usr/local/sbin/permanently-banned.sh
		rm -r -f ./usr/local/share/router/firewall
		rm ./usr/local/etc/rc.local.d/S02_permanently-banned.rc
		echo 'firewall=n' >> ./out/config.rc
		break
	fi
done
while true; do
	echo -n ' [ 3/15] localdns (y/n) '
	read localdns
	if [ "$localdns" = 'y' ]; then
		echo 'localdns=y' >> ./out/config.rc
		break
	fi
	if [ "$localdns" = 'n' ]; then
		rm ./etc/init.d/dnsmasq-hosts-build
		rm ./usr/local/etc/hosts.d
		rm ./usr/local/etc/init.d/dnsmasq-hosts-build
		rm ./usr/local/sbin/generate-dns-hosts.sh
		rm -r -f ./usr/local/share/router/localdns
		echo 'localdns=n' >> ./out/config.rc
		break
	fi
done
while true; do
	echo -n ' [ 4/15] notify-daemon (y/n) '
	read notify_daemon
	if [ "$notify_daemon" = 'y' ]; then
		echo 'notify_daemon=y' >> ./out/config.rc
		break
	fi
	if [ "$notify_daemon" = 'n' ]; then
		rm ./usr/local/etc/notify-daemon
		rm ./usr/local/sbin/notify-daemon-state.sh
		rm ./usr/local/sbin/notify-daemon.sh
		rm -r -f ./usr/local/share/router/notify-daemon
		rm ./usr/local/etc/rc.local.d/S16_notify-daemon.rc
		echo 'notify_daemon=n' >> ./out/config.rc
		break
	fi
done
while true; do
	echo -n ' [ 5/15] resolvconf_updater (y/n) '
	read resolvconf_updater
	if [ "$resolvconf_updater" = 'y' ]; then
		echo 'resolvconf_updater=y' >> ./out/config.rc
		break
	fi
	if [ "$resolvconf_updater" = 'n' ]; then
		rm ./usr/local/etc/resolvconf-updater.d
		rm ./usr/local/sbin/resolvconf-updater.sh
		rm -r -f ./usr/local/share/router/resolvconf-updater
		rm ./usr/local/etc/rc.local.d/S18_resolvconf-updater.rc
		echo 'resolvconf_updater=n' >> ./out/config.rc
		break
	fi
done
while true; do
	echo -n ' [ 6/15] webadmin (y/n) '
	read webadmin
	if [ "$webadmin" = 'y' ]; then
		echo 'webadmin=y' >> ./out/config.rc
		break
	fi
	if [ "$webadmin" = 'n' ]; then
		rm ./usr/local/sbin/httpd_php-start.sh
		rm ./usr/local/share/www
		rm -r -f ./usr/local/share/router/webadmin
		rm ./usr/local/etc/rc.local.d/S12_webadmin.rc
		echo 'webadmin=n' >> ./out/config.rc
		break
	fi
done
while true; do
	echo -n ' [ 7/15] generate-ddns-hosts (y/n) '
	read generate_ddns_hosts
	if [ "$generate_ddns_hosts" = 'y' ]; then
		echo 'generate_ddns_hosts=y' >> ./out/config.rc
		break
	fi
	if [ "$generate_ddns_hosts" = 'n' ]; then
		rm ./usr/local/sbin/generate-ddns-hosts.sh
		echo 'generate_ddns_hosts=n' >> ./out/config.rc
		break
	fi
done
while true; do
	echo -n ' [ 8/15] ntpdate-daemon (y/n) '
	read ntpdate_daemon
	if [ "$ntpdate_daemon" = 'y' ]; then
		echo 'ntpdate_daemon=y' >> ./out/config.rc
		break
	fi
	if [ "$ntpdate_daemon" = 'n' ]; then
		rm ./usr/local/sbin/ntpdate-daemon.sh
		rm ./usr/local/etc/rc.local.d/S20_ntpdate.rc
		echo 'ntpdate_daemon=n' >> ./out/config.rc
		break
	fi
done
while true; do
	echo -n ' [ 9/15] set-zram (y/n) '
	read set_zram
	if [ "$set_zram" = 'y' ]; then
		echo 'set_zram=y' >> ./out/config.rc
		break
	fi
	if [ "$set_zram" = 'n' ]; then
		rm ./usr/local/sbin/set-zram.sh
		rm ./usr/local/etc/rc.local.d/S32_zram.rc
		echo 'set_zram=n' >> ./out/config.rc
		break
	fi
done
while true; do
	echo -n ' [10/15] system_autoupdate (y/n) '
	read system_autoupdate
	if [ "$system_autoupdate" = 'y' ]; then
		echo 'system_autoupdate=y' >> ./out/config.rc
		break
	fi
	if [ "$system_autoupdate" = 'n' ]; then
		rm ./usr/local/sbin/system-autoupdate.sh
		rm ./usr/local/etc/rc.local.d/S14_autoupdate.rc
		echo 'system_autoupdate=n' >> ./out/config.rc
		break
	fi
done
while true; do
	echo -n ' [11/15] isc-dhcp-server config (y/n) '
	read isc_dhcp_server
	if [ "$isc_dhcp_server" = 'y' ]; then
		echo 'isc_dhcp_server=y' >> ./out/config.rc
		break
	fi
	if [ "$isc_dhcp_server" = 'n' ]; then
		rm -r -f ./usr/local/etc/dhcp
		echo 'isc_dhcp_server=n' >> ./out/config.rc
		break
	fi
done
while true; do
	echo -n ' [12/15] dnsmasq config (y/n) '
	read dnsmasq
	if [ "$dnsmasq" = 'y' ]; then
		echo 'dnsmasq=y' >> ./out/config.rc
		break
	fi
	if [ "$dnsmasq" = 'n' ]; then
		rm -r -f ./etc/dnsmasq.d
		rm -r -f ./usr/local/etc/dnsmasq
		echo 'dnsmasq=n' >> ./out/config.rc
		break
	fi
done
while true; do
	echo -n ' [13/15] php tweaks (y/n) '
	read php
	if [ "$php" = 'y' ]; then
		echo 'php=y' >> ./out/config.rc
		break
	fi
	if [ "$php" = 'n' ]; then
		rm -r -f ./etc/php
		rm -r -f ./usr/local/etc/php
		echo 'php=n' >> ./out/config.rc
		break
	fi
done
while true; do
	echo -n ' [14/15] sysctl tweaks (y/n) '
	read sysctl
	if [ "$sysctl" = 'y' ]; then
		echo 'sysctl=y' >> ./out/config.rc
		break
	fi
	if [ "$sysctl" = 'n' ]; then
		rm -r -f ./etc/sysctl.d
		rm -r -f ./usr/local/etc/sysctl.d
		echo 'sysctl=n' >> ./out/config.rc
		break
	fi
done
while true; do
	echo -n ' [15/15] udev tweaks (y/n) '
	read udev
	if [ "$udev" = 'y' ]; then
		echo 'udev=y' >> ./out/config.rc
		break
	fi
	if [ "$udev" = 'n' ]; then
		rm -r -f ./etc/udev
		rm -r -f ./usr/local/etc/udev
		echo 'udev=n' >> ./out/config.rc
		break
	fi
done

echo; echo ' Cleaning...'
[ "$(ls ./etc/init.d)" = "" ] && rm -r -f ./etc/init.d
[ "$(ls ./usr/local/etc/init.d)" = "" ] && rm -r -f ./usr/local/etc/init.d
[ "$(ls ./usr/local/share/router)" = "" ] && rm -r -f ./usr/local/share/router
[ "$(ls ./usr/local/share)" = "" ] && rm -r -f ./usr/local/share

echo; echo ' Creating tarballs:'; echo

echo ' - usr/local/etc'
cd ./usr/local/etc
tar cf ../../../out/local_etc.tar *
cd ../../..

echo ' - usr/local/sbin'
cd ./usr/local/sbin
tar cf ../../../out/local_sbin.tar *
cd ../../..

if [ -e ./usr/local/share ]; then
	echo ' - usr/local/share'
	cd ./usr/local/share
	tar cf ../../../out/local_share.tar *
	cd ../../..
fi

echo ' - etc/apt/apt.conf.d'
cd ./etc/apt/apt.conf.d
tar cf ../../../out/etc_apt-conf-d.tar *
cd ../../..

if [ -e ./etc/acpi ]; then
	echo ' - etc/acpi'
	cd ./etc/acpi
	tar cf ../../out/etc_acpi.tar *
	cd ../..
fi

if [ -e ./etc/dnsmasq.d ]; then
	echo ' - etc/dnsmasq.d'
	cd ./etc/dnsmasq.d
	tar cf ../../out/etc_dnsmasq.tar *
	cd ../..
fi

if [ -e ./etc/init.d ]; then
	echo ' - etc/init.d'
	cd ./etc/init.d
	tar cf ../../out/etc_initd.tar * .legacy-bootordering
	cd ../..
fi

if [ -e ./etc/php/7.0/cli/conf.d ]; then
	echo ' - etc/php/7.0/cli/conf.d'
	cd ./etc/php/7.0/cli/conf.d
	tar cf ../../../../../out/etc_php.tar *
	cd ../../../../..
fi

if [ -e ./etc/sysctl.d ]; then
	echo ' - etc/sysctl.d'
	cd ./etc/sysctl.d
	tar cf ../../out/etc_sysctl.tar *
	cd ../..
fi

if [ -e ./etc/udev ]; then
	echo ' - etc/udev'
	cd ./etc/udev/rules.d
	tar cf ../../../out/etc_udev.tar *
	cd ../../..
fi

echo ' - etc'
cd ./etc
tar cf ../out/etc.tar rc.local
cd ..

echo; echo ' Creating tarball..'
cd ./out
tar cf ../debian-router.tar *
cd ..
gzip -9 ./debian-router.tar

echo; echo ' Cleaning...'
rm -r -f ./etc
rm -r -f ./out
rm -r -f ./usr

echo; echo ' Creating setup script...'
echo '#!/bin/sh
echo; echo " debian router v1 - setup script"

echo; echo " Unpacking..."; echo
mkdir /tmp/debian-router-setup-temps > /dev/null 2>&1 || exit 1
cd /tmp/debian-router-setup-temps
tar xf /debian-router.tar.gz || exit 1
cd /

echo " Importing settings..."
. /tmp/debian-router-setup-temps/config.rc

echo; echo " Preparing..."
echo " - /usr/local/etc"
if [ ! -e /usr/local/etc ]; then
	mkdir /usr/local/etc
	chown root:root /usr/local/etc
fi
cd /usr/local/etc
tar xf /tmp/debian-router-setup-temps/local_etc.tar

echo " - /etc/apt/apt.conf.d"
cd /etc/apt/apt.conf.d
tar xf /tmp/debian-router-setup-temps/etc_apt-conf-d.tar
cd /

echo; echo " Installing packages..."; echo
[ "$acpid_mods" = "y" ] && apt-get install -y acpi-support-base
[ "$firewall" = "y" ] && apt-get install -y iptables ebtables
[ "$webadmin" = "y" ] && apt-get install -y php7.0-cli dash
[ "$ntpdate_daemon" = "y" ] && apt-get install -y ntpdate
[ "$isc_dhcp_server" = "y" ] && apt-get install -y isc-dhcp-server
[ "$dnsmasq" = "y" ] && apt-get install -y dnsmasq
[ -e /tmp/debian-router-setup-temps/etc_initd.tar ] && apt-get install -y sysvinit-core

echo; echo " Deploying..."; echo

echo " - /usr/local/sbin"
cd /usr/local/sbin
tar xf /tmp/debian-router-setup-temps/local_sbin.tar

if [ -e /tmp/debian-router-setup-temps/local_share.tar ]; then
	echo " - /usr/local/share"
	cd /usr/local/share
	tar xf /tmp/debian-router-setup-temps/local_share.tar
fi

if [ -e /tmp/debian-router-setup-temps/etc_acpi.tar ]; then
	echo " - /etc/acpi"
	cd /etc/acpi
	tar xf /tmp/debian-router-setup-temps/etc_acpi.tar
fi

if [ -e /tmp/debian-router-setup-temps/etc_dnsmasq.tar ]; then
	echo " - /etc/dnsmasq.d"
	cd /etc/dnsmasq.d
	tar xf /tmp/debian-router-setup-temps/etc_dnsmasq.tar
fi

if [ -e /tmp/debian-router-setup-temps/etc_initd.tar ]; then
	echo " - /etc/init.d"
	cd /etc/init.d
	tar xf /tmp/debian-router-setup-temps/etc_initd.tar
fi

if [ -e /tmp/debian-router-setup-temps/etc_php.tar ]; then
	echo " - /etc/php/7.0/cli/conf.d"
	cd /etc/php/7.0/cli/conf.d
	tar xf /tmp/debian-router-setup-temps/etc_php.tar
fi

if [ -e /tmp/debian-router-setup-temps/etc_sysctl.tar ]; then
	echo " - /etc/sysctl.d"
	cd /etc/sysctl.d
	tar xf /tmp/debian-router-setup-temps/etc_sysctl.tar
fi

if [ -e /tmp/debian-router-setup-temps/etc_udev.tar ]; then
	echo " - /etc/udev/rules.d"
	cd /etc/udev/rules.d
	tar xf /tmp/debian-router-setup-temps/etc_udev.tar
fi

echo " - /etc"
cd /etc
tar xf /tmp/debian-router-setup-temps/etc.tar

echo; echo " Cleaning..."
cd /
apt-get clean
rm -r -f /tmp/debian-router-setup-temps

echo; echo " Setup init scripts..."

if [ "$firewall" = "y" ]; then
	echo " - firewall & firewall6"
	insserv firewall
fi

if [ "$localdns" = "y" ]; then
	echo " - localdns"
	insserv dc_dnsmasq-hosts-build
fi

echo; echo " Done! Reboot system"

rm /debian-router.tar.gz
rm /setup.sh
exit 0
' > setup.sh

echo; echo ' Done!'; echo
echo ' Send debian-router.tar.gz and setup.sh to your server'
echo ' and place this files in /'
echo ' then chmod 755 setup.sh and run /setup.sh as root'; echo
rm ./configure.sh
exit 0
