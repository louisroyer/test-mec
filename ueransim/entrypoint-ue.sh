#!/usr/bin/env bash
# Running configuration script
if [ ! -z "$CONFIG_SCRIPT" ]; then
	/usr/bin/env $CONFIG_SCRIPT
fi

# Waiting before starting
if [ ! -z "$SLEEP" ]; then
	echo "[$(date --iso-8601=s)] Starting in $SLEEP seconds" > /dev/stderr
	sleep $SLEEP
fi
# Starting
nr-ue "$@" &

# Waiting pdu session
if [ -z "$ROUTING_SLEEP" ]; then
	ROUTING_SLEEP=2
fi
if [ ! -z "$ROUTING" ]; then
	until /usr/bin/env $ROUTING
	do
		echo "[$(date --iso-8601=s)] Waiting creation of PDU session: Retrying in $ROUTING_SLEEP seconds">/dev/stderr
		sleep $ROUTING_SLEEP
	done
	echo "[$(date --iso-8601=s)] Route to Data Network created successfully"
fi
sleep infinity
