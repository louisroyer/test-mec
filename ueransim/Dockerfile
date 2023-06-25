
### UERANSIM-GNB ###
FROM ubuntu:22.04  AS ueransim-gnb
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    lksctp-tools iproute2 ethtool \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*
COPY ./entrypoint-gnb.sh /usr/local/bin/entrypoint.sh
ENV CONFIG_SCRIPT ""
ENV ROUTING ""
ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]

### UERANSIM-UE ###
FROM ubuntu:22.04 AS ueransim-ue
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    lksctp-tools \
    iproute2 iputils-ping wget bind9-dnsutils\
    && rm -rf /var/lib/apt/lists/*

COPY ./entrypoint-ue.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
