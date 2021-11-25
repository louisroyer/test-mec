#!/usr/bin/env bash
iptables -t nat -A POSTROUTING -o "$(ip r ls |awk '{print $5; exit}')" -j MASQUERADE
iptables -I FORWARD -j ACCEPT

TRUNK_UP=10.0.216.3
ip route add 10.0.223.0/24 via $TRUNK_UP

# route mec
ip route add 10.0.215.0/24 via $TRUNK_UP
