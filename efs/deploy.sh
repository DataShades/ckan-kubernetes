#!/usr/bin/env bash

. ../common/coreConfig.sh

# Attach policies to pull down images from the ECR
aws iam attach-role-policy --role-name masters.${NAME} --policy-arn "arn:aws:iam::aws:policy/AmazonElasticFileSystemReadOnlyAccess"
aws iam attach-role-policy --role-name nodes.${NAME} --policy-arn "arn:aws:iam::aws:policy/AmazonElasticFileSystemReadOnlyAccess"

applyLocalConfig clusterrole_efs
applyLocalConfig clusterrolebinding_efs
applyLocalConfig configmap_efs
applyLocalConfig serviceaccount_efs
applyLocalConfig deployment_efs
applyLocalConfig storageclass_efs