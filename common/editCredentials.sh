#!/usr/bin/env bash

ansible-vault --vault-password-file=~/.ansible/ld-vault-key \
    edit \
    ./credentials/aws/ld_prototype_access
