#!/usr/bin/env bash

if [ -n "${CONFIG_SCRIPT}" ]; then
	/usr/bin/env "${CONFIG_SCRIPT}"
fi
if [ -n "${ROUTING}" ]; then
	/usr/bin/env "${ROUTING}"
fi
if [ -n "${SLEEP}" ]; then
	echo "[$(date --iso-8601=s)] Starting in ${SLEEP} seconds" > /dev/stderr
	sleep "${SLEEP}"
fi
exec smf "$@"
