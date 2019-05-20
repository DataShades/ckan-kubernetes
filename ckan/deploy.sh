#!/usr/bin/env bash

. ../common/coreConfig.sh

#applyLocalConfig persistentvolumeclaim_ckanbase_c1
applyLocalConfig deployment_ckanbase_c1
applyLocalConfig service_ckanbase_c1
applyLocalConfig ingress_ckanbase_c1