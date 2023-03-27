#!/bin/bash

pid=0

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}
GROUP_ID=${LOCAL_GROUP_ID:-9001}

# Handle Docker SIGTERM
term_handler() {
  if [ $pid -ne 0 ]; then
    # Stop VRisingServer.exe and wait for it to exit.
    kill -SIGINT "$pid"
    tail --pid=$pid -f /dev/null
  fi
  exit 143; # 128+15 SIGTERM
}

# Trap Docker SIGTERM
trap 'kill ${!}; term_handler' SIGTERM

echo "Starting with UID : ${USER_ID}"
mkdir -p ${INSTALL_DIR} && \
    groupadd -g ${GROUP_ID} vrising && \
    useradd -m -s /bin/false -u ${USER_ID} -g ${GROUP_ID} vrising && \
    mkdir -p ${INSTALL_DIR} && \
    chown -R vrising:vrising ${INSTALL_DIR}

exec gosu vrising "$@" &

# Wait for wine to start VRisingServer.exe
while true
do
  pid=$(ps aux | grep vrising\\\\VRisingServer.exe | awk '{print $2}')
  if [ -n "$pid" ]; then
    break
  fi
  sleep 1
done

# Killed by Docker SIGTERM trap
while true
do
  tail -f /dev/null & wait ${!}
done
