FROM steamcmd/steamcmd:ubuntu-20 as builder
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y \
 && apt-get install -y --no-install-recommends wine-stable wine32 wine64 xvfb gosu  \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /
ENV INSTALL_DIR="/vrising"
RUN mkdir -p $INSTALL_DIR
ARG APPID=1829350
ARG STEAM_BETAS
RUN steamcmd \
        +force_install_dir $INSTALL_DIR \
        +login anonymous \
        +app_update $APPID $STEAM_BETAS validate \
        +app_update 1007 validate \
        +quit

WORKDIR ${INSTALL_DIR}
RUN mkdir -p server-data
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

FROM builder as runner
ARG TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
WORKDIR /vrising
CMD ["tini", "-s", "--", "xvfb-run", "-a", "wine", "./VRisingServer.exe", "-persistentDataPath", "./server-data"]
