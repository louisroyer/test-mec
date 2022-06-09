FROM debian:bullseye-slim AS nextmn-upf
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    iproute2 iputils-ping tshark iptables build-essential bash-completion \
    && rm -rf /var/lib/apt/lists/*

# Developpment setup, installation is done in entrypoint
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
CMD ["-h"]
