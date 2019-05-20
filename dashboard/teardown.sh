#!/usr/bin/env bash

. ../common/coreConfig.sh

delete deployment monitoring-grafana
delete service monitoring-grafana

delete deployment monitoring-influxdb
delete service monitoring-influxdb

delete deployment heapster
delete service heapster
delete serviceaccount heapster
delete clusterrolebinding heapster

delete clusterrolebinding kubernetes-dashboard
delete ingress kubernetes-dashboard
delete service kubernetes-dashboard
delete deployment kubernetes-dashboard
delete rolebinding kubernetes-dashboard-minimal
delete serviceaccount kubernetes-dashboard