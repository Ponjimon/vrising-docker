#!/bin/sh
pwd
ls -lha .
echo "DEBUG: ${USER} $(id -u) $(id -g)"
tini -- xvfb-run -a wine ./VRisingServer.exe -persistentDataPath ./server-data