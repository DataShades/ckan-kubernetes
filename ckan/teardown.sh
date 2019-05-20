#!/usr/bin/env bash

. ../common/coreConfig.sh

deleteInNs service ckan-base client1
deleteInNs deployment ckan-base client1
deleteInNs ingress ckan-base client1
#deleteInNs persistentvolumeclaim ckan-efs client1