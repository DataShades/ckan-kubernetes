#!/usr/bin/env bash

. ../common/coreConfig.sh

SOLRCKAN_CURRENT_DIR=`pwd`
SOLRCKAN_DOCKER_CONTEXT_DIR=${SOLRCKAN_CURRENT_DIR}/docker

REPO_HUB="860798832671.dkr.ecr.ap-southeast-2.amazonaws.com"

BASE_IMAGE="${REPO_HUB}/ckan-solr:base"
DEFAULT_IMAGE="${REPO_HUB}/ckan-solr:default"

docker build -t "${BASE_IMAGE}" -f "${SOLRCKAN_DOCKER_CONTEXT_DIR}/Dockerfile.base" "${SOLRCKAN_DOCKER_CONTEXT_DIR}"

docker push ${BASE_IMAGE}