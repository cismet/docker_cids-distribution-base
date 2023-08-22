#!/bin/bash

IMAGE_NAME=reg.cismet.de/abstract/cids-distribution-base
IMAGE_VERSION=8.1-debian


# RELEASE BUILD ----------------------------------------------------------------
docker build \
  -f Dockerfile \
  --build-arg IMAGE_VERSION=${IMAGE_VERSION} \
  -t ${IMAGE_NAME} \
  -t ${IMAGE_NAME}:${IMAGE_VERSION} \
  .