FROM golang:1.17 AS f5gc-populate-builder
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
     ca-certificates git build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
ENV TMPENV=1
ENV BRANCH=pdusessiontype
RUN  git -C / clone --depth 1 --quiet -b "$BRANCH"  https://github.com/louisroyer/free5gc-populate
WORKDIR /free5gc-populate
RUN  go build -o /go/bin/free5gc-populate main.go

FROM golang:1.17 AS builder

ARG F5GCPOPULATE_RELEASE
RUN : ${F5GCPOPULATE_RELEASE:? Missing build-arg F5GCPOPULATE_RELEASE.} && go install github.com/shynuu/free5gc-populate@${F5GCPOPULATE_RELEASE}

FROM debian:bullseye-slim
COPY --from=f5gc-populate-builder /go/bin/free5gc-populate /usr/local/sbin/free5gc-populate
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
