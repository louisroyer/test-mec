#!/usr/bin/env bash
iptables -t nat -A POSTROUTING -o $(ip r ls |awk '{print $5; exit}') -j MASQUERADE
iptables -I FORWARD -j ACCEPT
