#!/usr/bin/env bash

. ../common/coreConfig.sh

applyLocalConfig clusterrole_traefik-proxy
applyLocalConfig clusterrolebinding_traefik-proxy
applyLocalConfig serviceaccount_traefik-proxy
applyLocalConfig deployment_traefik-proxy
applyLocalConfig service_traefik-proxy
applyLocalConfig service_traefik-web-ui
applyLocalConfig ingress_traefik-web-ui
