#!/usr/bin/env bash
set -e # exit if pdu session not established

if [ -n "${DNS}" ]; then
	ip route add "${DNS}" via "$(ip a|grep inet|grep uesimtun|awk '{print $2;exit}'|awk 'BEGIN {FS ="/"}; {print $1;exit}')"
	echo "nameserver ${DNS}"  > /etc/resolv.conf
	echo "[$(date --iso-8601=s)] DNS set to ${DNS}" > /dev/stderr
fi

