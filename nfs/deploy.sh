#!/usr/bin/env bash

. ../common/coreConfig.sh

applyLocalConfig persistentvolumeclaim_nfs_c1
applyLocalConfig deployment_nfs_c1
applyLocalConfig service_nfs_c1