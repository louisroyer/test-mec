FROM debian:bullseye-slim
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    microsocks \
    && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["microsocks"]
CMD ["-1", "-u", "user", "-P", "password"] 
