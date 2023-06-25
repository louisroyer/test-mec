#!/usr/bin/env bash
# Running configuration script
if [ -n "${CONFIG_SCRIPT}" ]; then
	/usr/bin/env "${CONFIG_SCRIPT}"
fi

# Waiting before starting
if [ -n "${SLEEP}" ]; then
	echo "[$(date --iso-8601=s)] Starting in ${SLEEP} seconds" > /dev/stderr
	sleep "${SLEEP}"
fi

exec nr-ue -c "$UE_CONFIG_FILE" &


sleep infinity
