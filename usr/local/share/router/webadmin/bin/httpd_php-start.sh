#!/bin/sh

# Settings
HOME='/usr/local/share/www'
ADDR='0.0.0.0'
PORT='80'
ROUTER_SCRIPT="$HOME/router.php"

LOG='/tmp/.php.log'
mountpoint -q /tmp || LOG='/dev/null'
log()
{
	echo "`date +%d.%m.%Y@%H:%M:%S` $@" >> $LOG 2>&1 || true
}
elog()
{
	log "E: $@"
	exit 1
}
[ -e $HOME ] || elog "$HOME not exist. Change it in $0"
[ -e $HOME/.disabled ] && elog "$HOME/.disabled exist. Aborting..."
log "Switching to php server with pid $$"
exec /usr/bin/php -S $ADDR:$PORT -t $HOME $ROUTER_SCRIPT >> $LOG 2>&1