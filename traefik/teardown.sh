#!/usr/bin/env bash

function delete {
    kubectl delete $1 $2 --namespace=kube-system
}

delete clusterrolebinding traefik-proxy
delete serviceaccount traefik-proxy
delete service traefik-web-ui
delete service traefik-proxy
delete deployment traefik-proxy
delete ingress traefik-web-ui