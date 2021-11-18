FROM debian:bullseye-slim
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    bind9 \
    && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["named"]
CMD ["--help"]
