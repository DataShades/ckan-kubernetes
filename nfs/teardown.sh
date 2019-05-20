#!/usr/bin/env bash

. ../common/coreConfig.sh

deleteInNs persistentvolumeclaim nfs-ebs client1
deleteInNs deployment nfs-server client1
deleteInNs service nfs-service client1