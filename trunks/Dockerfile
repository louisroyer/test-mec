FROM louisroyer/base-irit:latest 
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    trunks tshark iputils-ping \
    && rm -rf /var/lib/apt/lists/*
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
ENV ROUTING ""
ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
