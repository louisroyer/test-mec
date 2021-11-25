#!/usr/bin/env bash

TRUNK_GW=10.0.217.3
GW_ROUTER=10.0.217.2
TRUNK_ST=10.0.218.3
ST_ROUTER=10.0.218.2

TABLE_TO_GW=100
TABLE_TO_ST=101

ip rule add iif "$(ip route get $ST_ROUTER | awk '{print $3; exit}')" table $TABLE_TO_GW
ip rule add iif "$(ip route get $GW_ROUTER | awk '{print $3; exit}')" table $TABLE_TO_ST
ip rule add from $TRUNK_GW table $TABLE_TO_GW
ip rule add from $TRUNK_ST table $TABLE_TO_ST 
ip route add default via $GW_ROUTER table $TABLE_TO_GW
ip route add default via $ST_ROUTER table $TABLE_TO_ST
