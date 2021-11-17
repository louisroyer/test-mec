FROM golang:1.17 AS builder

ARG F5GCPOPULATE_RELEASE
RUN : ${F5GCPOPULATE_RELEASE:? Missing build-arg F5GCPOPULATE_RELEASE.} && go install github.com/shynuu/free5gc-populate@${F5GCPOPULATE_RELEASE}

FROM debian:bullseye-slim
COPY --from=builder /go/bin/free5gc-populate /usr/local/sbin/free5gc-populate
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
