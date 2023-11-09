#!/usr/bin/env python3
import yaml
import ipaddress
import json

def _network(name: str, ipv4_prefix: str, ipv6_prefix: str | None = None, container_iface_name: str | None = None):
    ipv4 = ipaddress.ip_network(ipv4_prefix)
    ipv4_subnets = list(ipv4.subnets(prefixlen_diff=1))
    if ipv6_prefix is not None:
        ipv6 = ipaddress.ip_network(ipv6_prefix)
        ipv6_subnets = list(ipv6.subnets(prefixlen_diff=1))


    net =  {
            "name": name,
            "enable_ipv6": ipv6_prefix is not None,
            "driver": "bridge",
            "driver_opts": {
                "com.docker.network.container_iface_prefix": f'{container_iface_name if container_iface_name is not None else name}-',
                "com.docker.network.bridge.name": name,
                },
            "ipam": {
                "driver": "default",
                "config": [ 
                           { 
                            "subnet": f'{ipv4}',
                            "ip_range": f'{ipv4_subnets[0]}',
                            "gateway": f'{next(ipv4_subnets[1].hosts())}',
                            },
                           ] 
                },
            }
    if ipv6_prefix is not None:
        net['ipam']['config'].append(
                {
                    "subnet": f'{ipv6}',
                    "ip_range": f'{ipv6_subnets[0]}',
                    "gateway": f'{next(ipv6_subnets[1].hosts())}',
                })
    res = {}
    res[name] = net

    return yaml.dump(res, sort_keys=False, default_flow_style=False)

def with_debug(service_name: str):
    return f'''{service_name}-debug:
  <<: *debug-common
  container_name: {service_name}-debug
  network_mode: service:{service_name}
{service_name}:'''

def with_debug_hidden(service_name: str):
    return f'''{service_name}-debug-hidden:
  <<: *debug-hidden-common
  container_name: {service_name}-debug
  network_mode: service:{service_name}
{service_name}:'''

def socks(service_name: str):
    return f'''{service_name}-socks:
  <<: *socks
  container_name: {service_name}-socks
  network_mode: service:{service_name}'''

def network(values: str):
    args = json.loads(values)
    return _network(**args)
    
