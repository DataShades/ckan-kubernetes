#!/usr/bin/env bash

. ../common/coreConfig.sh

deleteInNs service ckan-solr client1
deleteInNs deployment ckan-solr client1