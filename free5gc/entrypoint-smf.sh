#!/usr/bin/env bash

if [ ! -z "$config_script" ]; then
	/usr/bin/env $config_script
fi
if [ ! -z "$routing" ]; then
	/usr/bin/env $routing
fi
if [ ! -z "$sleep" ]; then
	echo "[$(date --iso-8601=s)] Starting in $sleep seconds" > /dev/stderr
	sleep $sleep
fi
exec smf "$@"
