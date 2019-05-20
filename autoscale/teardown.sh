#!/usr/bin/env bash

. ../common/coreConfig.sh

aws iam detach-role-policy --role-name masters.${NAME} --policy-arn ${AUTOSCALE_POLICY_ARN}
aws iam detach-role-policy --role-name nodes.${NAME} --policy-arn ${AUTOSCALE_POLICY_ARN}

aws iam detach-role-policy --role-name masters.${NAME} --policy-arn "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
aws iam detach-role-policy --role-name nodes.${NAME} --policy-arn "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

aws iam delete-policy --policy-arn ${AUTOSCALE_POLICY_ARN}

deleteInNs serviceaccount cluster-autoscaler kube-system
delete clusterrolebinding cluster-autoscaler
deleteInNs rolebinding cluster-autoscaler kube-system
deleteInNs deployment cluster-autoscaler kube-system