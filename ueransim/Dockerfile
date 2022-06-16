#### IPERF-BUILDER ###
FROM debian:bullseye-slim AS iperf-builder
ARG IPERF2_RELEASE
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    git build-essential ca-certificates\
    && rm -rf /var/lib/apt/lists/*
WORKDIR /iperf
RUN : ${IPERF2_RELEASE:? Missing build-arg IPERF2_RELEASE.} && git clone -b ${IPERF2_RELEASE} --depth 1 https://git.code.sf.net/p/iperf2/code iperf2-source
WORKDIR /iperf/iperf2-source
RUN ./configure && make && make install

### UERANSIM-GNB ###
FROM louisroyer/base-irit:latest as ueransim-gnb
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    tshark wireshark-ueransim-rls \
    lksctp-tools iproute2 ethtool \
    iputils-ping \
    libglib2.0 libgcrypt20 libpcap0.8-dev libssh-4 libc-ares2 liblua5.2-0 \
    && rm -rf /var/lib/apt/lists/*
COPY ./entrypoint-gnb.sh /usr/local/bin/entrypoint.sh
COPY ./nr-gnb /usr/local/bin/nr-gnb
ENV CONFIG_SCRIPT ""
ENV ROUTING ""
ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]

### UERANSIM-UE ###
FROM louisroyer/base-irit:latest as ueransim-ue
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    tshark ueransim wireshark-ueransim-rls \
    lksctp-tools \
    iproute2 iputils-ping wget bind9-dnsutils \
    libglib2.0 libgcrypt20 libpcap0.8-dev libssh-4 libc-ares2 liblua5.2-0 \
    && rm -rf /var/lib/apt/lists/*
# IPERF2
COPY --from=iperf-builder /usr/local/bin/iperf /usr/local/bin/iperf
COPY ./entrypoint-ue.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
