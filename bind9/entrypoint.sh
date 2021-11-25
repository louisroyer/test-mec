#!/usr/bin/env bash
if [ -n "${ROUTING}" ]; then
	/usr/bin/env "${ROUTING}"
fi
exec named "$@"
