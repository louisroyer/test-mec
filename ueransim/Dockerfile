FROM debian:bullseye-slim AS cmake-builder
ARG CMAKE_RELEASE=v3.20.0
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    make g++ git ca-certificates libssl-dev \
    && rm -rf /var/lib/apt/lists/*
RUN : ${CMAKE_RELEASE:? Missing build-arg CMAKE_RELEASE.} && git clone -b $CMAKE_RELEASE --depth 1 https://github.com/Kitware/CMake --quiet
WORKDIR CMake
RUN ./bootstrap && make && make install


FROM debian:bullseye-slim AS builder
ARG UERANSIM_RELEASE
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    make g++ git ca-certificates libsctp-dev \
    && rm -rf /var/lib/apt/lists/*
COPY --from=cmake-builder /usr/local/share/cmake-3.20 /usr/local/share/cmake-3.20
COPY --from=cmake-builder /usr/local/bin/cmake /usr/local/bin/cmake
RUN : ${UERANSIM_RELEASE:? Missing build-arg UERANSIM_RELEASE.} && git clone -b $UERANSIM_RELEASE --depth 1  https://github.com/aligungr/UERANSIM --quiet
WORKDIR UERANSIM
RUN make

FROM debian:bullseye-slim AS iperf-builder
ARG IPERF2_RELEASE
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    git build-essential ca-certificates\
    && rm -rf /var/lib/apt/lists/*
WORKDIR /iperf
RUN : ${IPERF2_RELEASE:? Missing build-arg IPERF2_RELEASE.} && git clone -b ${IPERF2_RELEASE} --depth 1 https://git.code.sf.net/p/iperf2/code iperf2-source
WORKDIR /iperf/iperf2-source
RUN ./configure && make && make install

FROM debian:bullseye-slim AS tshark-builder
ARG TSHARK_RELEASE
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    git ca-certificates build-essential cmake \
    flex bison \
    libglib2.0-dev libgcrypt20-dev libpcap0.8-dev libssh-dev libc-ares-dev liblua5.2-dev \
    && rm -rf /var/lib/apt/lists/*
RUN : ${TSHARK_RELEASE:? Missing build-arg TSHARK_RELEASE.} && git clone -b $TSHARK_RELEASE --depth 1 https://github.com/wireshark/wireshark --quiet
WORKDIR wireshark
RUN cmake -DBUILD_wireshark=OFF . && make && make install

FROM debian:bullseye-slim AS rls-builder
ARG RLS_RELEASE
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    git ca-certificates \
    && rm -rf /var/lib/apt/lists/*
RUN : ${RLS_RELEASE:? Missing build-arg RLS_RELEASE.} && mkdir -p /usr/local/lib/wireshark/plugins &&  git -C /usr/local/lib/wireshark/plugins clone -b $RLS_RELEASE --depth 1 https://github.com/louisroyer/RLS-wireshark-dissector

FROM debian:bullseye-slim as ueransim-gnb
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    lksctp-tools iproute2 ethtool \
    iputils-ping \
    libglib2.0 libgcrypt20 libpcap0.8-dev libssh-4 libc-ares2 liblua5.2-0 \
    && rm -rf /var/lib/apt/lists/*
# TSHARK + RLS
COPY --from=tshark-builder /usr/local/share/wireshark /usr/local/share/wireshark
COPY --from=tshark-builder /usr/local/bin/* /usr/local/bin/
COPY --from=tshark-builder /usr/local/lib/wireshark/ /usr/local/lib/wireshark
COPY --from=tshark-builder /usr/local/lib/*.so /usr/local/lib/
RUN ldconfig
COPY --from=rls-builder /usr/local/lib/wireshark/plugins/RLS-wireshark-dissector/ /usr/local/lib/wireshark/plugins/RLS-wireshark-dissector/
# GNB
COPY --from=builder UERANSIM/build/nr-cli /usr/local/bin/nr-cli
COPY --from=builder UERANSIM/build/nr-gnb /usr/local/bin/nr-gnb
COPY ./entrypoint-gnb.sh /usr/local/bin/entrypoint.sh
ENV CONFIG_SCRIPT ""
ENV ROUTING ""
ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]

FROM debian:bullseye-slim as ueransim-ue
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    lksctp-tools \
    iproute2 iputils-ping wget bind9-dnsutils \
    libglib2.0 libgcrypt20 libpcap0.8-dev libssh-4 libc-ares2 liblua5.2-0 \
    && rm -rf /var/lib/apt/lists/*
# TSHARK + RLS
COPY --from=tshark-builder /usr/local/share/wireshark /usr/local/share/wireshark
COPY --from=tshark-builder /usr/local/bin/* /usr/local/bin/
COPY --from=tshark-builder /usr/local/lib/wireshark/ /usr/local/lib/wireshark
COPY --from=tshark-builder /usr/local/lib/*.so /usr/local/lib/
RUN ldconfig
COPY --from=rls-builder /usr/local/lib/wireshark/plugins/RLS-wireshark-dissector/ /usr/local/lib/wireshark/plugins/RLS-wireshark-dissector/
# IPERF2
COPY --from=iperf-builder /usr/local/bin/iperf /usr/local/bin/iperf
# UE
COPY --from=builder UERANSIM/build/nr-cli /usr/local/bin/nr-cli
COPY --from=builder UERANSIM/build/nr-ue /usr/local/bin/nr-ue
COPY ./entrypoint-ue.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
