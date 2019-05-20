#!/usr/bin/env bash

. ../common/coreConfig.sh

CKANBASE_CURRENT_DIR=`pwd`
CKANBASE_DOCKER_CONTEXT_DIR=${CKANBASE_CURRENT_DIR}/docker

REPO_HUB="860798832671.dkr.ecr.ap-southeast-2.amazonaws.com"

BASE_IMAGE="${REPO_HUB}/ckan-datapusher:base"
TEST_IMAGE="${REPO_HUB}/ckan-datapusher:test"
DEFAULT_IMAGE="${REPO_HUB}/ckan-datapusher:default"
CLIENT1_IMAGE="${REPO_HUB}/ckan-datapusher:client1"
CLIENT2_IMAGE="${REPO_HUB}/ckan-datapusher:client2"

docker build -t "${TEST_IMAGE}" -f "${CKANBASE_DOCKER_CONTEXT_DIR}/Dockerfile.test" "${CKANBASE_DOCKER_CONTEXT_DIR}"

docker push ${TEST_IMAGE}

#docker build -t "${BASE_IMAGE}" -f "${CKANBASE_DOCKER_CONTEXT_DIR}/Dockerfile.base" "${CKANBASE_DOCKER_CONTEXT_DIR}"

#docker push ${BASE_IMAGE}

#docker build -t "${CLIENT1_IMAGE}" -f "${CKANBASE_DOCKER_CONTEXT_DIR}/Dockerfile.client1" "${CKANBASE_DOCKER_CONTEXT_DIR}"

#docker push ${CLIENT1_IMAGE}

#docker build -t "${CLIENT2_IMAGE}" -f "${CKANBASE_DOCKER_CONTEXT_DIR}/Dockerfile.client2" "${CKANBASE_DOCKER_CONTEXT_DIR}"

#docker push ${CLIENT2_IMAGE}