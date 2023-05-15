FROM golang:1.18 AS builder
ARG NEXTMNUPF_RELEASE
RUN : ${NEXTMNUPF_RELEASE:? Missing build-arg NEXTMNUPF_RELEASE.} && GOPRIVATE=github.com/louisroyer/nextmn-upf go install github.com/louisroyer/nextmn-upf@${NEXTMNUPF_RELEASE}

FROM debian:bullseye-slim AS nextmn-upf
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    iproute2 iputils-ping tshark iptables build-essential bash-completion \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/nextmn-upf /usr/local/sbin/nextmn-upf
# Developpment setup, installation is done in entrypoint
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["-h"]
