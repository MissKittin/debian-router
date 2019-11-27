# (not tested yet!)
I wrote from memory, I could forget something
<br><br>

# hint
If you making changes in /etc/* files, copy original `file` to `file.bak`, move `file` to `/usr/local/etc` and link from `/usr/local/etc` to `etc`. It will be easier for you to find configuration files.
<br><br>

# debian debootstrap
I recommend installing debian via debootstrap. You will have a clean and not bloated system.<br>
So, run your favourite debian-based distro on your pc (or virtual machine) and install debootstrap: `apt-get install debootstrap`<br>
OK, now open root's terminal and create a directory where you will work: `mkdir debianrouter`<br>
Download base system: `debootstrap --variant=minbase --arch amd64 stretch ./debianrouter http://deb.debian.org/debian/` where arch is server cpu architecture (amd64 is x64, i386 is x86).<br>
Debian is downloaded, configure it.
<br><br>

# preconfigure
First go to the new system: `chroot ./debianrouter`<br>
add new user: `adduser yourusername`<br>
and change root password: `passwd root`<br>
In debian you can control packages that you have installed, but now it's like mess. Clean it:<br><br>
`apt-mark auto adduser apt base-files base-passwd bash bsdutils coreutils dash debconf debian-archive-keyring debianutils diffutils dpkg e2fslibs e2fsprogs findutils gcc-6-base gpgv grep gzip hostname init-system-helpers login mawk mount multiarch-support ncurses-base ncurses-bin passwd perl-base sed sensible-utils sysvinit-utils tar util-linux zlib1g`<br>
<br>
`apt-mark showmanual | grep "^lib" | while read line; do apt-mark auto $line; done`<br>
<br>
You can run `apt-mark showmanual` - you will see a few packages without dependencies.<br>
Now you have to install kernel: `apt-get install --no-install-recommends linux-image-amd64` or other kernel that you want.<br>
You certainly don't want \*.old files, remove it: `rm /vmlinuz.old; rm /initrd.img.old`<br>
Install bootloader in your system: `apt-get install --no-install-recommends grub-pc`<br>
Here you can't connect this system to the internet, install network: `apt-get install netbase ifupdown`<br>
If you want ifconfig tool install net-tools: `apt-get install net-tools`<br>
**! you might need firmware for your hardware**<br>
Now you have installed all packages that you need to boot the system, but not now.
<br><br>

# configure
Now edit some config files: open file manager as root and edit:<br>
etc/fstab:<br>
```
# Linux
tmp	/tmp		tmpfs	auto			0	0
tmp	/var/tmp	tmpfs	auto			0	0

# Root
/dev/sda1		/	ext4	auto,suid,dev,noatime,nodiratime,async,discard,barrier=0,commit=60	0	1
```
Comment out all lines in `etc/apt/sources.list`. In `etc/apt/sources.list.d/stretch.list` put
```
# LiveCD repo
deb http://http.debian.net/debian stretch main contrib non-free
#deb-src http://http.debian.net/debian stretch main contrib non-free
deb http://security.debian.org stretch/updates main contrib non-free
#deb-src http://security.debian.org stretch/updates main contrib non-free

# Backports
#deb http://ftp.pl.debian.org/debian stretch-backports main contrib non-free
#deb-src http://ftp.pl.debian.org/debian stretch-backports main contrib non-free

# Updates
#deb http://ftp.pl.debian.org/debian stretch-updates main contrib non-free
#deb-src http://ftp.pl.debian.org/debian stretch-updates main contrib non-free

# Proposed updates
#deb http://ftp.pl.debian.org/debian stretch-proposed-updates main contrib non-free
#deb-src http://ftp.pl.debian.org/debian stretch-proposed-updates main contrib non-free
```
etc/hostname: rename debian to your_hostname<br>
etc/hosts: add to end of file `127.0.0.1 your_hostname`<br>
etc/network/interfaces.d: create new file and write `iface YOUR_WAN_INTERFACE inet dhcp` to this file<br>
Clean some directories - remove all files from `dev` and `run`
<br><br>

# create debian-router package
`chmod 755 configure.sh` and run this as root.
<br><br>

# prepare the hardware
Assembly your server, connect display and keyboard.<br>
Boot your favourite linux distro on your server, run gparted and make partition(s) on hdd.
<br><br>

# transfer & install
Make tarball of your new root (`tar cvf root.tar *` and optionally compress it `gzip root.tar`).<br>
Transfer root.tar (or root.tar.gz), debian-router.tar.gz and setup.sh to your server.<br>
On server mount hdd root partition, open console in mountpoint (you should see only lost+found in `ls`), unpack rootfs (`tar xvf /path/to/root.tar_or_tar.gz`) and `cp /path/to/debian-router.tar.gz .; cp /path/to/setup.sh .`<br>
Now as root:<br>
`for i in dev dev/pts proc run sys; do mount --bind /${i} ./${i}; done`<br>
`chroot .`<br>
`grub-install /dev/HDD_NAME`<br>
If grub is successfully installed, type<br>
`exit`<br>
`for i in dev/pts dev proc run sys; do umount ./${i}; done`<br>
Close all file managers and text editors, umount hdd partition and boot server from hdd.
<br><br>

# install debian-router package
Login as root and type: `cd /; chmod 755 /setup.sh; /setup.sh`
<br><br>

# check internet connection
If you aren't connected to the internet, connect now: `ifup YOUR_WAN_INTERFACE`<br>
If you see `Ignoring unknown interface` type `ip link show` and correct /etc/network/interfaces.d/YOUR_FILE_NAME: `cd /etc/network/interfaces.d; echo 'iface YOUR_WAN_INTERFACE inet dhcp' > YOUR_FILE_NAME`
<br><br>

# time zone
Run `dpkg-reconfigure tzdata` and select your location.<br>
You can also run `ntpdate-debian` to synchronize hardware clock.
<br><br>

# install more packages
It's headless server, install the ssh: `apt-get install openssh-server`<br>
Bootlogd creates boot log in /var/log/boot, if you want this: `apt-get install bootlogd` and move `/etc/rc2.d/S**bootlogd` to `/etc/rc2.d/S01bootlogd` (of curse if you installed sysvinit and using default rc2 runlevel)<br>
You might need sudo: `apt-get install sudo` and put in /etc/sudoers.d/yourusername: `YOUR_USER_NAME	ALL=PASSWD: ALL`<br>
Now install all programs that you need, eg: midnight commander, mousepad, synaptic etc
<br><br>

# tweaks
soon
<br><br>

# the end
Uncomment backports, updates and proposed-updates in `/etc/apt/sources.list.d/stretch.list`. The content should be like this:
```
# LiveCD repo
deb http://http.debian.net/debian stretch main contrib non-free
#deb-src http://http.debian.net/debian stretch main contrib non-free
deb http://security.debian.org stretch/updates main contrib non-free
#deb-src http://security.debian.org stretch/updates main contrib non-free

# Backports
deb http://ftp.pl.debian.org/debian stretch-backports main contrib non-free
#deb-src http://ftp.pl.debian.org/debian stretch-backports main contrib non-free

# Updates
deb http://ftp.pl.debian.org/debian stretch-updates main contrib non-free
#deb-src http://ftp.pl.debian.org/debian stretch-updates main contrib non-free

# Proposed updates
deb http://ftp.pl.debian.org/debian stretch-proposed-updates main contrib non-free
#deb-src http://ftp.pl.debian.org/debian stretch-proposed-updates main contrib non-free
```
Upgrade system: `apt-get upgrade` (if you have dependency problems, use `apt-get dist-upgrade`)<br>
Clean apt and dpkg: `apt-get autoremove --purge; apt-get clean`<br>
`halt` server, unplug the power cord and disconnect displays, keyboard, mouse etc, plug power cord and power on your server. Now you can enter by ssh: `ssh YOUR_NOT_ROOT_USERNAME@YOUR_SERVER_IP -X` where `-X` is Xorg forwarding (on windows use eg putty and xming).<br>
For X11 forwarding you need xauth. To run programs with sudo, you need link .Xauthority: `sudo ln -s /home/yourusername/.Xauthority /root/.Xauthority`
