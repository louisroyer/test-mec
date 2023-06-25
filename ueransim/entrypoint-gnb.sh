#!/usr/bin/env bash
# Running configuration script
if [ -n "${CONFIG_SCRIPT}" ]; then
	/usr/bin/env "${CONFIG_SCRIPT}"
fi
if [ -n "${ROUTING}" ]; then
	/usr/bin/env "${ROUTING}"
fi

exec nr-gnb -c "$GNB_CONFIG_FILE" &

sleep infinity 
