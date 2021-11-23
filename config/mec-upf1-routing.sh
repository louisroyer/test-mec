#!/usr/bin/env bash
TRUNK_UP=10.0.215.3
TRUNK_CP=10.0.213.4
# route upf
ip route add 10.0.216.0/24 via $TRUNK_UP
# route dns mno
ip route add 10.0.224.0/24 via $TRUNK_UP

# route smf
ip route add 10.0.210.0/24 via $TRUNK_CP

