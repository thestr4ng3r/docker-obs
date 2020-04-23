#!/bin/bash

docker run --shm-size 1g -p 3389:3389 -p 2222:22 \
   	-it obs "$@"

#	-v "obs-home:/home/user" \


