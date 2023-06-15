FROM golang:1.18 AS builder

ARG NEXTMNSR_RELEASE
RUN : ${NEXTMNSR_RELEASE:? Missing build-arg NEXTMNSR_RELEASE.} && GOPRIVATE=github.com/louisroyer/nextmn-srv6 go install github.com/louisroyer/nextmn-srv6@${NEXTMNSR_RELEASE}

FROM debian:bookworm-slim as nextmn-srv6
RUN apt-get update && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    iproute2 iptables  \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /go/bin/nextmn-srv6 /usr/local/sbin/nextmn-srv6
ENTRYPOINT ["nextmn-srv6"]
CMD ["--help"]
