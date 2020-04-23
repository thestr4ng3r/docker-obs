#!/bin/bash

set -x

cd "$(dirname "$(readlink -f "$0")")"

if [ -f local.sh ]; then
	. local.sh
fi

EXTRA_ARGS=()
if [ $PASSWORDHASH ]; then
	EXTRA_ARGS+=(-e PASSWORDHASH="$PASSWORDHASH")
fi
if [ $OBSHOME ]; then
	EXTRA_ARGS+=(-v "$OBSHOME:/home/user")
fi

docker run \
	--shm-size 1g \
	-p 3389:3389 \
	-p 2222:22 \
	--name obs \
	--rm \
	"${EXTRA_ARGS[@]}" \
   	-it obs "$@"

