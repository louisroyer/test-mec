#!/usr/bin/env bash

if [ ! -z "$CONFIG_SCRIPT" ]; then
	/usr/bin/env $CONFIG_SCRIPT
fi
if [ ! -z "$ROUTING" ]; then
	/usr/bin/env $ROUTING
fi
exec free5gc-upfd "$@"
