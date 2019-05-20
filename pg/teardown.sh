#!/usr/bin/env bash

. ../common/coreConfig.sh

deleteInNs deployment ckan-pg client1
deleteInNs service ckan-pg client1
deleteInNs secret ckan-pg client1
deleteInNs persistentvolumeclaim ckan-pg client1
#deleteInNs persistentvolume ckan-pg client1