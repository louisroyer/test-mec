#!/usr/bin/env bash

if [ ! -z "$CONFIG_SCRIPT" ]; then
	/usr/bin/env $CONFIG_SCRIPT
fi
if [ ! -z "$ROUTING" ]; then
	/usr/bin/env $ROUTING
fi
if [ ! -z "$SLEEP" ]; then
	echo "[$(date --iso-8601=s)] Starting in $SLEEP seconds" > /dev/stderr
	sleep $SLEEP
fi
exec smf "$@"
