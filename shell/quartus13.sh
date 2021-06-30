#!/bin/bash

QUARTUS13_IMAGE=${QUARTUS13_IMAGE:-"quartus:13.0.1.2"}
LICENSE_MAC=${LICENSE_MAC:-"00:FF:FF:FF:FF:FF"}
LM_LICENSE_FILE=${LM_LICENSE_FILE:-"$HOME/.Altera/quartus.dat"}
MGLS_LICENSE_FILE=${MGLS_LICENSE_FILE:-"$HOME/.Altera/modelsim.dat"}

QUARTUS_PATH=/opt/altera/13.0sp1/quartus/linux64

docker run --rm \
--user $(id -u):$(id -g) \
-e DISPLAY \
-e PATH=/bin:/sbin:$QUARTUS_PATH \
-e LD_LIBRARY_PATH=$QUARTUS_PATH \
-e LM_LICENSE_FILE=$LM_LICENSE_FILE \
-e MGLS_LICENSE_FILE=$MGLS_LICENSE_FILE \
--mac-address=$LICENSE_MAC \
-v /etc/passwd:/etc/passwd:ro \
-v /etc/group:/etc/group:ro  \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v $HOME:$HOME \
-w $PWD \
--ipc=host \
-v /dev/bus/usb:/dev/bus/usb \
--device-cgroup-rule='c *:* rmw' \
--security-opt seccomp=unconfined \
-ti $QUARTUS13_IMAGE $@
