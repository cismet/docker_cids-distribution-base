#!/bin/bash

IMAGE_NAME=reg.cismet.de/abstract/cids-distribution-base
IMAGE_VERSION=6.1-debian
IMAGE_BASE=debian


# RELEASE BUILD ----------------------------------------------------------------
docker build \
  -f Dockerfile_${IMAGE_BASE} \
  --build-arg IMAGE_VERSION=${IMAGE_VERSION} \
  -t ${IMAGE_NAME} \
  -t ${IMAGE_NAME}:${IMAGE_VERSION} \
  .
