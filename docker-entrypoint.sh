#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}
GROUP_ID=${LOCAL_GROUP_ID:-9001}

echo "Starting with UID : ${USER_ID}"
mkdir -p ${INSTALL_DIR} && \
    groupadd -g ${GROUP_ID} vrising && \
    useradd -m -s /bin/false -u ${USER_ID} -g ${GROUP_ID} vrising && \
    mkdir -p ${INSTALL_DIR} && \
    chown -R vrising:vrising ${INSTALL_DIR}

exec gosu vrising "$@"