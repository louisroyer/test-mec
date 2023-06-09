#!/usr/bin/env bash

# Add nei sid
ip -6 route add fd00:51D5:0001::/48 via fd00:d0cc:e700:3333:1::2 proto static

# Add sr route
ip sr tunsrc set fd00:51D5:0002::


# 1. End.M.GTP6.E instance and set TEID to 1
# 2. gNB instance
ip route add 10.0.221.0/24 encap seg6 mode encap segs fd00:51D5:0001:020a:00c9:0600:0000:0001 dev linux-sr proto static
# gnb3: 10.0.201.6 => 0A.00.C9.06 / QFI+R+U = 00 / TEID = 0000.0001


# route to other DN
# en dur pour l’instant, à changer
ip route add 10.0.111.0/24 via 10.0.224.4 proto static
ip route add 10.0.222.0/24 via 10.0.224.2 proto static

# nat
#ip route replace default via 10.0.224.1 dev n6-0 proto static
#iptables -t nat -A POSTROUTING -o "$(ip r ls |awk '{print $5; exit}')" -j MASQUERADE
#iptables -I FORWARD -j ACCEPT
