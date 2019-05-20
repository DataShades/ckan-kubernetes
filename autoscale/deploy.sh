#!/usr/bin/env bash

. ../common/coreConfig.sh

function tagAsg {
    groupNamePrefix=$1

    asgName=${groupNamePrefix}.${NAME}

    aws autoscaling create-or-update-tags --region ${AWS_REGION} --tags "ResourceId=${asgName},ResourceType=auto-scaling-group,Key=k8s.io/cluster-autoscaler/enabled,Value=,PropagateAtLaunch=true"
    aws autoscaling create-or-update-tags --region ${AWS_REGION} --tags "ResourceId=${asgName},ResourceType=auto-scaling-group,Key=kubernetes.io/cluster/${NAME},Value=,PropagateAtLaunch=true"
}

# Attach policies to roles to scale up and scale down the cluster
aws iam create-policy --policy-name ${AUTOSCALE_POLICY_NAME} --policy-document file://./aws/autoscalingPolicy.json
aws iam attach-role-policy --role-name masters.${NAME} --policy-arn ${AUTOSCALE_POLICY_ARN}
aws iam attach-role-policy --role-name nodes.${NAME} --policy-arn ${AUTOSCALE_POLICY_ARN}

# Attach policies to pull down images from the ECR
aws iam attach-role-policy --role-name masters.${NAME} --policy-arn "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
aws iam attach-role-policy --role-name nodes.${NAME} --policy-arn "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

tagAsg nodes
tagAsg gc_m5l
tagAsg gc_m4l
tagAsg gc_t2l
tagAsg gc_m5xl
tagAsg gc_m4xl
tagAsg gc_t2xl
tagAsg mo_r4l
tagAsg mo_r3l
tagAsg mo_r4xl
tagAsg mo_r3xl
tagAsg mo_r42xl
tagAsg mo_r32xl

applyLocalConfig role_autoscale
applyLocalConfig rolebinding_autoscale
applyLocalConfig clusterrole_autoscale
applyLocalConfig clusterrolebinding_autoscale
applyLocalConfig serviceaccount_autoscale
applyLocalConfig deployment_autoscale