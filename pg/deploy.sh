#!/usr/bin/env bash

. ../common/coreConfig.sh

deploySecret secret_ckanpg_c1
#applyLocalConfig persistentvolume_ckanpg_c1
applyLocalConfig persistentvolumeclaim_ckanpg_c1
applyLocalConfig deployment_ckanpg_c1
applyLocalConfig service_ckanpg_c1
