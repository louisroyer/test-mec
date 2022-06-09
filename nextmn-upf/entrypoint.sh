#!/usr/bin/env bash

if [ -n "${FORCE_REINSTALL}" ]; then
	make reinstall
fi

if [ -n "${ROUTING}" ]; then
	/usr/bin/env "${ROUTING}"
fi
exec nextmn-upf "$@"

