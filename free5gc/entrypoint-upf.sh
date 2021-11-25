#!/usr/bin/env bash

if [ -n "${CONFIG_SCRIPT}" ]; then
	/usr/bin/env "${CONFIG_SCRIPT}"
fi
if [ -n "${ROUTING}" ]; then
	/usr/bin/env "${ROUTING}"
fi
exec free5gc-upfd "$@"
