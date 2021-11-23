FROM debian:bullseye-slim as router 
RUN apt-get update && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    iproute2 tshark iputils-ping iptables \
    && rm -rf /var/lib/apt/lists/*
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
ENV ROUTING ""
ENTRYPOINT ["entrypoint.sh"]
