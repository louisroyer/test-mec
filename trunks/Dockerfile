FROM golang:1.17 AS builder
ARG TRUNKS_RELEASE
RUN : ${TRUNKS_RELEASE:? Missing build-arg TRUNKS_RELEASE.} && go install github.com/shynuu/trunks@${TRUNKS_RELEASE}

## Installation from fork
#RUN mkdir -p /go/src/github.com/louisroyer && git -C /go/src/github.com/louisroyer/ clone -b use-path --depth 1 https://github.com/louisroyer/trunks trunks
#WORKDIR /go/src/github.com/louisroyer/trunks
#RUN go build && go install

FROM debian:bullseye-slim
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    iproute2 iptables procps tshark iputils-ping \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /go/bin/trunks /usr/local/sbin/trunks
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
ENV ROUTING ""
ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
