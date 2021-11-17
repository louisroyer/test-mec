#!/usr/bin/env bash

if [ ! -z "$config_script" ]; then
	/usr/bin/env $config_script
fi
if [ ! -z "$routing" ]; then
	/usr/bin/env $routing
fi
exec amf "$@"
