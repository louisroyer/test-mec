#!/usr/bin/env bash
if [ ! -z "$ROUTING" ]; then
	/usr/bin/env $ROUTING
fi
exec named "$@"