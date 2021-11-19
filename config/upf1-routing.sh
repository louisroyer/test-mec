#!/usr/bin/env bash
iptables -t nat -A POSTROUTING -o $(ip r ls |awk '{print $5; exit}') -j MASQUERADE
iptables -I FORWARD -j ACCEPT
ip route add 10.0.223.0/24 via 10.0.210.4
