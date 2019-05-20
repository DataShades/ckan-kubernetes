#!/usr/bin/env bash

. ../common/coreConfig.sh

PGCKAN_CURRENT_DIR=`pwd`
PGCKAN_DOCKER_CONTEXT_DIR=${PGCKAN_CURRENT_DIR}/docker

REPO_HUB="860798832671.dkr.ecr.ap-southeast-2.amazonaws.com"

BASE_IMAGE="${REPO_HUB}/ckan-pg:base"
DEFAULT_IMAGE="${REPO_HUB}/ckan-pg:default"

docker build -t "${BASE_IMAGE}" -f "${PGCKAN_DOCKER_CONTEXT_DIR}/Dockerfile.base" "${PGCKAN_DOCKER_CONTEXT_DIR}"

docker push ${BASE_IMAGE}