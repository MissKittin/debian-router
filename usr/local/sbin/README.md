# miscellaneous scripts
generate-ddns-hosts.sh -> bridge beetwen isc-dhcp-server and dnsmasq's dns<br>
ntpdate-daemon.sh -> first wait for internet connection, then synchronize<br>
remount-relatime.sh -> remount all with relatime to noatime<br>
set-zram.sh -> enable || disable zram swap<br>
system-autoupdate.sh -> run apt-get update every n hours<br><br>

# generate-ddns-hosts.sh
add to dhcpd.conf:<br><br>
`on commit {`<br>
`	set ClientNum = binary-to-ascii(10, 8, ".", leased-address);`<br>
`	set ClientMac = binary-to-ascii(16, 8, ":", substring(hardware, 1, 6));`<br>
`	set ClientHost = pick-first-value( `<br>
`		host-decl-name,`<br>
`		option fqdn.hostname,`<br>
`		option host-name,`<br>
`		"none");`<br>
`	execute("/usr/local/sbin/generate-ddns-hosts.sh", "commit", ClientNum, ClientMac, ClientHost);`<br>
`}`
