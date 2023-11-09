#!/usr/bin/env bash

if [ -n "${CONFIG_SCRIPT}" ]; then
	/usr/bin/env "${CONFIG_SCRIPT}"
fi
exec n3iwf "$@"
