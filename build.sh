#!/bin/bash

DOCKERHUB_REPO='biobright/python3-opencv3'

# allows env var to be overridden by shell, e.g. USECUDA=OFF ./build.sh
: ${USECUDA:=OFF}

if [ "${USECUDA}" = "ON" ]; then TAG='cuda'; else TAG='nocuda'; fi

docker build -t ${DOCKERHUB_REPO}:${TAG} . \
&& docker push ${DOCKERHUB_REPO}:${TAG}