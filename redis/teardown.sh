#!/usr/bin/env bash

. ../common/coreConfig.sh

deleteInNs service ckan-redis client1
deleteInNs deployment ckan-redis client1