#!/usr/bin/env bash

MNO_DNS_PUBLIC=10.0.224.3
MEC_UPF=10.0.223.2
ip route add 10.0.222.0/24 via $MEC_UPF
ip route add 10.0.218.0/24 via 10.0.217.3
ip addr add $MNO_DNS_PUBLIC dev $(ip route get $MEC_UPF|awk '{print $3;exit}')
