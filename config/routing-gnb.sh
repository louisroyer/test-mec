#!/usr/bin/env bash

# route amf
ip route add 10.0.214.0/24 via 10.0.213.4
ip route add fd00:d0cc:e700:1111:3::/80 via fd00:d0cc:e700:1111:2::4
