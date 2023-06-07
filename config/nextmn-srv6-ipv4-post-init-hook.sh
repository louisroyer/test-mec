#!/usr/bin/env bash

# Add nei sid
ip -6 route add fd00:51D5:0000:1::/64 via fd00:d0cc:e700:3333:1::2 proto static

# Add sr route
ip sr tunsrc set fd00:51D5:0000:2::


# 1. End.M.GTP6.E instance and set TEID to 1
# 2. gNB instance
ip route add 10.0.112.0/24 encap seg6 mode encap segs fd00:51D5:0000:1:69:0000:0000:0100,fd00:d0cc:e700:1111:3:8000:0:3 dev linux-sr proto static
