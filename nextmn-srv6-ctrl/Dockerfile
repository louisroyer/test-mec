FROM golang:1.18 AS builder

ARG NEXTMNSRCTRL_RELEASE
RUN : ${NEXTMNSRCTRL_RELEASE:? Missing build-arg NEXTMNSRCTRL_RELEASE.} && GOPRIVATE=github.com/nextmn/srv6-ctrl go install github.com/nextmn/srv6-ctrl@${NEXTMNSRCTRL_RELEASE}

FROM debian:bookworm-slim as nextmn-srv6-ctrl
COPY --from=builder /go/bin/srv6-ctrl /usr/local/sbin/srv6-ctrl
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
