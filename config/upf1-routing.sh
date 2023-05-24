#!/usr/bin/env bash
ip route replace default via 10.0.224.1 dev n6-0 proto static
iptables -t nat -A POSTROUTING -o "$(ip r ls |awk '{print $5; exit}')" -j MASQUERADE
iptables -I FORWARD -j ACCEPT

#TRUNK_UP=10.0.216.3
#ip route add 10.0.223.0/24 via $TRUNK_UP proto static

# route mec
#ip route add 10.0.215.0/24 via $TRUNK_UP proto static

# route to other DN
# en dur pour l’instant, à changer
#ip route add  10.0.111.0/24 via 10.0.224.4 proto static
