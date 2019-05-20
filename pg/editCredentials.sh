#!/usr/bin/env bash

ansible-vault --vault-password-file=~/.ansible/ld-vault-key \
    edit \
    ./k8s/secret_ckanpg_c1.yaml
