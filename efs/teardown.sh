#!/usr/bin/env bash

. ../common/coreConfig.sh

aws iam detach-role-policy --role-name masters.${NAME} --policy-arn "arn:aws:iam::aws:policy/AmazonElasticFileSystemReadOnlyAccess"
aws iam detach-role-policy --role-name nodes.${NAME} --policy-arn "arn:aws:iam::aws:policy/AmazonElasticFileSystemReadOnlyAccess"

delete StorageClass aws-efs
deleteInNs serviceaccount efs-provisioner kube-system
deleteInNs Deployment efs-provisioner kube-system
deleteInNs ConfigMap efs-provisioner kube-system
delete clusterrolebinding run-efs-provisioner