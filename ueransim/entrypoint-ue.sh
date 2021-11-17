#!/usr/bin/env bash
CONFIG_FILE=/etc/ueransim/config.yaml
if [ ! -z "$config_script" ]; then
	/usr/bin/env $config_script
fi
if [ ! -z "$sleep" ]; then
	echo "[$(date --iso-8601=s)] Starting in $sleep seconds" > /dev/stderr
	sleep $sleep
fi
exec nr-ue "$@"
