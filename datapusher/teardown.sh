#!/usr/bin/env bash

. ../common/coreConfig.sh

deleteInNs service ckan-datapusher client1
deleteInNs deployment ckan-datapusher client1