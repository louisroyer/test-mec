#!/usr/bin/env bash

# Add nei sid
ip route replace fd00:1::/32 via fd00:0:0:0:4:8000:0:2
ip route replace fd00:2::/32 via fd00:0:0:0:4:8000:0:3
ip route replace fd00:3::/32 via fd00:0:0:0:4:8000:0:4


