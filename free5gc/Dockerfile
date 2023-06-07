FROM golang:1.17 AS builder
ARG F5GC_RELEASE
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    autoconf automake cmake gcc libtool pkg-config libmnl-dev libyaml-dev \
#     ca-certificates \
#    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
#    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
#    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
#    && apt-get update -q \
#    && apt-get install -qy --no-install-recommends --no-install-suggests \
#    nodejs yarn \
    && rm -rf /var/lib/apt/lists/*

RUN : ${F5GC_RELEASE:? Missing build-arg F5GC_RELEASE.} && git -C /go/src clone -b $F5GC_RELEASE --depth 1 --shallow-submodules --recursive --quiet -j $(nproc) https://github.com/free5gc/free5gc

WORKDIR /go/src/free5gc
RUN make nfs

#FROM debian:bullseye-slim AS free5gc-upf
#RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
#    libmnl0 libyaml-0-2 iptables \
#    iproute2 iputils-ping tshark ethtool \
#    && rm -rf /var/lib/apt/lists/*
#COPY --from=builder /go/src/free5gc/NFs/upf/build/bin/free5gc-upfd /usr/local/bin/free5gc-upfd 
#COPY --from=builder /go/src/free5gc/NFs/upf/build/updk/src/third_party/libgtp5gnl/lib/libgtp5gnl.so.0 /usr/local/lib/libgtp5gnl.so.0
#COPY --from=builder /go/src/free5gc/NFs/upf/build/utlt_logger/liblogger.so /usr/local/lib/liblogger.so
#RUN ldconfig
#COPY ./entrypoint-upf.sh /usr/local/bin/entrypoint.sh
#ENV ROUTING ""
#ENV CONFIG_SCRIPT ""
#ENTRYPOINT ["entrypoint.sh"]
#CMD ["-h"]

FROM golang:1.17 AS upf-builder
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    autoconf automake cmake gcc libtool pkg-config libmnl-dev libyaml-dev ca-certificates git build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
RUN  git -C / clone --depth 1 --quiet -b recoverytimestamp https://github.com/louisroyer/free5gc-upf
WORKDIR /free5gc-upf
RUN mkdir build
WORKDIR /free5gc-upf/build
RUN   cmake .. && make

FROM debian:bullseye-slim AS free5gc-upf
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    libmnl0 libyaml-0-2 iptables \
    iproute2 iputils-ping tshark ethtool \
    && rm -rf /var/lib/apt/lists/*
COPY --from=upf-builder /free5gc-upf/build/bin/free5gc-upfd /usr/local/bin/free5gc-upfd 
COPY --from=builder /go/src/free5gc/NFs/upf/build/updk/src/third_party/libgtp5gnl/lib/libgtp5gnl.so.0 /usr/local/lib/libgtp5gnl.so.0
COPY --from=builder /go/src/free5gc/NFs/upf/build/utlt_logger/liblogger.so /usr/local/lib/liblogger.so
RUN ldconfig
COPY ./entrypoint-upf.sh /usr/local/bin/entrypoint.sh
ENV ROUTING ""
ENV CONFIG_SCRIPT ""
ENTRYPOINT ["entrypoint.sh"]
CMD ["-h"]

FROM debian:bullseye-slim AS free5gc-amf
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    iproute2 iputils-ping tshark ethtool \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /go/src/free5gc/bin/amf /usr/local/bin/amf
COPY ./entrypoint-amf.sh /usr/local/bin/entrypoint.sh
ENV ROUTING ""
ENV CONFIG_SCRIPT ""
ENTRYPOINT ["entrypoint.sh"]
CMD ["-h"]

FROM golang:1.17 AS smf-builder
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    autoconf automake cmake gcc libtool pkg-config libmnl-dev libyaml-dev ca-certificates git build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
ENV TMPENV=4
ENV BRANCH=fix-ipv4v6
RUN  git -C / clone --depth 1 --quiet -b "$BRANCH"  https://github.com/louisroyer/free5gc-smf
WORKDIR /free5gc-smf
RUN mkdir /go/src/free5gc/bin -p
WORKDIR /free5gc-smf/cmd
RUN  CGO_ENABLED=0 go build -o /go/src/free5gc/bin/smf main.go


FROM debian:bullseye-slim as free5gc-smf
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    iproute2 iputils-ping tshark ethtool \
    && rm -rf /var/lib/apt/lists/*
COPY --from=smf-builder /go/src/free5gc/bin/smf /usr/local/bin/smf
COPY ./entrypoint-smf.sh /usr/local/bin/entrypoint.sh
ENV ROUTING ""
ENV CONFIG_SCRIPT ""
ENV SLEEP ""
ENTRYPOINT ["entrypoint.sh"]
CMD ["-h"]

FROM debian:bullseye-slim as free5gc-nrf
COPY --from=builder /go/src/free5gc/bin/nrf /usr/local/bin/nrf
ENTRYPOINT ["nrf"]
CMD ["-h"]

FROM debian:bullseye-slim as free5gc-ausf
COPY --from=builder /go/src/free5gc/bin/ausf /usr/local/bin/ausf
ENTRYPOINT ["ausf"]
CMD ["-h"]

FROM debian:bullseye-slim as free5gc-n3iwf
COPY --from=builder /go/src/free5gc/bin/n3iwf /usr/local/bin/n3iwf
ENTRYPOINT ["n3iwf"]
CMD ["-h"]

FROM debian:bullseye-slim as free5gc-nssf
COPY --from=builder /go/src/free5gc/bin/nssf /usr/local/bin/nssf
ENTRYPOINT ["nssf"]
CMD ["-h"]

FROM debian:bullseye-slim as free5gc-pcf
COPY --from=builder /go/src/free5gc/bin/pcf /usr/local/bin/pcf
ENTRYPOINT ["pcf"]
CMD ["-h"]

FROM debian:bullseye-slim as free5gc-udm
COPY --from=builder /go/src/free5gc/bin/udm /usr/local/bin/udm
ENTRYPOINT ["udm"]
CMD ["-h"]

FROM debian:bullseye-slim as free5gc-udr
COPY --from=builder /go/src/free5gc/bin/udr /usr/local/bin/udr
ENTRYPOINT ["udr"]
CMD ["-h"]

#FROM debian:bullseye-slim as free5gc-webui
#COPY --from=builder /go/src/free5gc/webconsole/bin/webconsole /usr/local/bin/webconsole
#RUN mkdir webconsole
#COPY --from=builder /go/src/free5gc/webconsole/public webconsole/public
#ENTRYPOINT ["webconsole"]
#CMD ["-h"]
