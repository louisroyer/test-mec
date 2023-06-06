FROM golang:1.18 AS builder

ARG NEXTMNSRCTRL_RELEASE
RUN : ${NEXTMNSRCTRL_RELEASE:? Missing build-arg NEXTMNSRCTRL_RELEASE.} && GOPRIVATE=github.com/louisroyer/nextmn-srv6-ctrl go install github.com/louisroyer/nextmn-srv6-ctrl@${NEXTMNSRCTRL_RELEASE}

FROM debian:bullseye-slim as nextmn-srv6-ctrl
COPY --from=builder /go/bin/nextmn-srv6-ctrl /usr/local/sbin/nextmn-srv6-ctrl
ENTRYPOINT ["nextmn-srv6-ctrl"]
CMD ["--help"]


