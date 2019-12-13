# debian-router
scripts from my home made router<br>
based on debian stretch, update to buster soon<br><br>

# read first
configs: https://github.com/MissKittin/debian-router/tree/master/usr/local/etc<br>
miscellaneous scripts: https://github.com/MissKittin/debian-router/tree/master/usr/local/sbin<br>
scripts and daemons: https://github.com/MissKittin/debian-router/tree/master/usr/local/share/router

# and then
read tutorial: https://github.com/MissKittin/debian-router/blob/master/HOWTO.md

# my hardware configuration
Motherboard: Gigabyte 880GA-UD3H rev 2.2<br>
CPU: AMD Athlon II X2 260u<br>
RAM: Kingston HyperX Savage DDR3 HX318C9SRK2/8 4GB overclocked to 1866MHz<br>
HDD: Kingston SSDNow V100 32GB Internal 2.5" (SV100S2/32G) SSD<br>
PSU: BeQuiet SYSTEM POWER S6-SYS-UA-300W<br>
WiFi AP: TP-LINK TL-WN881ND Rev:2.0<br>
LAN 1Gbps: TP-LINK TG-3468v2<br>
LAN 100Mbps: Realtek RTL8139D<br>
Case: old AT/ATX case with psu parallel to the motherboard

# my debian configuration
Init: SysVinit with init-parallel script and networking init script mod (will be commited soon), boot time: <del>10.48s</del> 6.92s<br>
Networking: LANs and WLAN bridged, PPTP and L2TP interfaces separated, optional teredo gateway (I don't recommend this way)

# in the future
overlayfs containers, qemu virtual machines (as daemon), pxe server and backupOS
