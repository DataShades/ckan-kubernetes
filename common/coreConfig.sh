#!/usr/bin/env bash
export AWS_REGION=ap-southeast-2
export AWS_ZONE=b
export CLUSTER_NAME=gluon
export CLUSTER_DOMAIN=k8s.datashades.links.com.au
export GENERAL_SWARM_MAX_NODES=10
export MEMORY_SWARM_MAX_NODES=10
export NISHI_IP=141.168.18.28
export AUTOSCALE_POLICY_NAME=kubernetesAutoscaling
export EFS_ID=fs-933aecaa

# Do not edit below this point
export AWS_AZ=${AWS_REGION}${AWS_ZONE}
export NAME=${CLUSTER_NAME}.${CLUSTER_DOMAIN}
export BUCKET_NAME=$(echo ${NAME} | sed -E 's/[\.]+/-/g')-state
export KEY_NAME=$(echo ${NAME} | sed -E 's/[\.]+/_/g')
export KOPS_STATE_STORE=s3://${BUCKET_NAME}
export KOPS_PUB_KEY_PARAM=~/.ssh/${KEY_NAME}
export KOPS_PUB_KEY=${KOPS_PUB_KEY_PARAM}.pub

# AWS Credentials
VAULT_TEMP_FILE=$(mktemp)
ansible-vault --vault-password-file=~/.ansible/ld-vault-key view ././../common/credentials/aws/ld_prototype_access > ${VAULT_TEMP_FILE}
export AWS_ACCESS_KEY_ID=$(cat ${VAULT_TEMP_FILE} | jq '.keyId' | sed 's/\"//g')
export AWS_SECRET_ACCESS_KEY=$(cat ${VAULT_TEMP_FILE} | jq '.accessKey' | sed 's/\"//g')
rm ${VAULT_TEMP_FILE}

export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --output text --query 'Account')
export AUTOSCALE_POLICY_ARN=arn:aws:iam::${AWS_ACCOUNT_ID}:policy/${AUTOSCALE_POLICY_NAME}
export REPOSITORY_URI=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/

# Useful functions for deployment scripts
function substituteParams {
    configFile=$1

    sed -i -e "s@{{AWS_REGION}}@${AWS_REGION}@g" "${configFile}"
    sed -i -e "s@{{AWS_ZONE}}@${AWS_ZONE}@g" "${configFile}"
    sed -i -e "s@{{CLUSTER_NAME}}@${CLUSTER_NAME}@g" "${configFile}"
    sed -i -e "s@{{CLUSTER_DOMAIN}}@${CLUSTER_DOMAIN}@g" "${configFile}"
    sed -i -e "s@{{EFS_ID}}@${EFS_ID}@g" "${configFile}"
    sed -i -e "s@{{GENERAL_SWARM_MAX_NODES}}@${GENERAL_SWARM_MAX_NODES}@g" "${configFile}"
    sed -i -e "s@{{GPU_SWARM_MAX_NODES}}@${GPU_SWARM_MAX_NODES}@g" "${configFile}"
    sed -i -e "s@{{ADMIN_IP}}@${ADMIN_IP}@g" "${configFile}"
    sed -i -e "s@{{AUTOSCALE_POLICY_NAME}}@${AUTOSCALE_POLICY_NAME}@g" "${configFile}"

    sed -i -e "s@{{AWS_AZ}}@${AWS_AZ}@g" "${configFile}"
    sed -i -e "s@{{NAME}}@${NAME}@g" "${configFile}"
    sed -i -e "s@{{BUCKET_NAME}}@${BUCKET_NAME}@g" "${configFile}"
    sed -i -e "s@{{KEY_NAME}}@${KEY_NAME}@g" "${configFile}"
    sed -i -e "s@{{KOPS_STATE_STORE}}@${KOPS_STATE_STORE}@g" "${configFile}"
    sed -i -e "s@{{KOPS_PUB_KEY_PARAM}}@${KOPS_PUB_KEY_PARAM}@g" "${configFile}"
    sed -i -e "s@{{KOPS_PUB_KEY}}@${KOPS_PUB_KEY}@g" "${configFile}"
    sed -i -e "s@{{AWS_ACCOUNT_ID}}@${AWS_ACCOUNT_ID}@g" "${configFile}"
    sed -i -e "s@{{AUTOSCALE_POLICY_ARN}}@${AUTOSCALE_POLICY_ARN}@g" "${configFile}"
}

function applyLocalConfig {
    baseFile=$1

    configFile=${baseFile}.yaml

    TEMP_DIR=$(mktemp -d)
    cp ./k8s/${configFile} ${TEMP_DIR}
    configFile=${TEMP_DIR}/${configFile}

    substituteParams ${configFile}

    kubectl apply -f ${configFile}

    rm -Rf ${TEMP_DIR}
}

function deploySecret {
    baseFile=$1

    configFile=${baseFile}.yaml

    # Get a temporary file to decrypt it to
    VAULT_TEMP_FILE=$(mktemp)

    # Decrypt the secret to the temp file
    ansible-vault --vault-password-file=~/.ansible/ld-vault-key view ./k8s/${configFile} > ${VAULT_TEMP_FILE}

    # Substitute in any params
    substituteParams ${VAULT_TEMP_FILE}

    # Create the secret using the decrypted file
    kubectl apply -f ${VAULT_TEMP_FILE}

    # Delete the temp file
    rm ${VAULT_TEMP_FILE}
}

function applyUrlConfig {
    kubectl apply -f $1
}

function delete {
    kubectl delete $1 $2
}

function deleteInNs {
    kubectl delete --namespace=$3 $1 $2
}

function loginToAWSECR {
    eval $(aws ecr get-login --no-include-email --region ${AWS_REGION} | sed 's|https://||')
}

loginToAWSECR