#!/usr/bin/env bash

# Add nei sid
ip -6 route add fd00:51D5:0000:2::/64 via fd00:d0cc:e700:3333:1::3 proto static
