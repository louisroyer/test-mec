FROM golang:1.18 AS builder

ARG NEXTMNSR_RELEASE
RUN : ${NEXTMNSR_RELEASE:? Missing build-arg NEXTMNSR_RELEASE.} && GOPRIVATE=github.com/nextmn/srv6 go install github.com/nextmn/srv6@${NEXTMNSR_RELEASE} \
  && ln -s /go/pkg/mod/github.com/nextmn/srv6@${NEXTMNSR_RELEASE} /configuration

FROM debian:bookworm-slim as nextmn-srv6
RUN apt-get update && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    iproute2 iptables  \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /go/bin/srv6 /usr/local/sbin/srv6
COPY --from=builder /configuration/etc/iproute2/rt_tables.d/nextmn.conf /etc/iproute2/rt_tables.d/nextmn.conf
COPY --from=builder /configuration/etc/iproute2/rt_protos.d/nextmn.conf /etc/iproute2/rt_protos.d/nextmn.conf
ENTRYPOINT ["srv6"]
CMD ["--help"]
