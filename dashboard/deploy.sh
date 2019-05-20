#!/usr/bin/env bash

. ../common/coreConfig.sh

applyUrlConfig https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/grafana.yaml
applyUrlConfig https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
applyUrlConfig https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
applyUrlConfig https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml
applyUrlConfig https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/alternative/kubernetes-dashboard.yaml
applyLocalConfig clusterrolebinding_kubernetes-dashboard
applyLocalConfig ingress_kubernetes-dashboard