#!/usr/bin/env bash

# Add route to RAN-MEC via UPF-I
ip route add 10.0.222.0/24 via 10.0.223.2 proto static
