FROM fragsoc/steamcmd-wine-xvfb

ENV INSTALL_DIR="/vrising"
ENV HOME=${INSTALL_DIR}

WORKDIR ${INSTALL_DIR}
RUN DEBIAN_FRONTEND=noninteractive apt-get update

# ARG UID=1000
# ARG GID=1000


# RUN mkdir -p $INSTALL_DIR && \
#     groupadd -g $GID vrising && \
#     useradd -m -s /bin/false -u $UID -g $GID vrising && \
#     mkdir -p $INSTALL_DIR && \
#     chown -R vrising:vrising ${INSTALL_DIR}

# USER vrising

# Install Server
ARG STEAM_BETAS
RUN steamcmd \
        +force_install_dir $INSTALL_DIR \
        +login anonymous \
        +app_update 1829350 $STEAM_BETAS validate \
        +app_update 1007 validate \
        +quit

# WORKDIR ${INSTALL_DIR}
RUN mkdir -p server-data
COPY docker-entrypoint.sh docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]