#!/usr/bin/env bash
TRUNK_UP=10.0.215.3
TRUNK_CP=10.0.213.4
DNS_MNO=10.0.224.3
DNS_MEC=10.0.223.3
# route upf
ip route add 10.0.216.0/24 via "${TRUNK_UP}" proto static

# route dns
ip route add "${DNS_MNO}" via "${DNS_MEC}" proto static

# route smf
ip route add 10.0.210.0/24 via "${TRUNK_CP}" proto static

# DNAT site2.test -> MEC
iptables -t nat -A PREROUTING -d 10.0.224.6 -j DNAT --to-destination 10.0.223.5

