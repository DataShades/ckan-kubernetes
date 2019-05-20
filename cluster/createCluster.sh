#!/usr/bin/env bash

. ../common/coreConfig.sh

function buildInstanceGroup {
    role=$2
    groupNamePrefix=$3
    ec2Type=$4
    spotMaxBid=$5
    maxNodes=$6
    minNodes=$7
    rootVolSize=$8

    configFile=ig_spot_swarm.yaml

    TEMP_DIR=$(mktemp -d)
    cp ./k8s/${configFile} ${TEMP_DIR}
    configFile=${TEMP_DIR}/${configFile}

    substituteParams ${configFile}

    sed -i -e "s@{{GROUP_NAME_PREFIX}}@${groupNamePrefix}@g" "${configFile}"
    sed -i -e "s@{{EC2_TYPE}}@${ec2Type}@g" "${configFile}"
    sed -i -e "s@{{SPOT_MAX_BID}}@${spotMaxBid}@g" "${configFile}"
    sed -i -e "s@{{MAX_NODES}}@${maxNodes}@g" "${configFile}"
    sed -i -e "s@{{MIN_NODES}}@${minNodes}@g" "${configFile}"
    sed -i -e "s@{{ROLE}}@${role}@g" "${configFile}"
    sed -i -e "s@{{ROOT_VOLUME_SIZE_IN_GB}}@${rootVolSize}@g" "${configFile}"

    kops $1 -f ${configFile}

    rm -Rf ${TEMP_DIR}
}

# Generate the key-pair for the cluster
ssh-keygen -t rsa -b 4096 -N '' -f ${KOPS_PUB_KEY_PARAM}

# Create S3 bucket
if ! aws s3api head-bucket --bucket "${BUCKET_NAME}" 2>/dev/null; then
    aws s3api create-bucket --bucket ${BUCKET_NAME} --create-bucket-configuration LocationConstraint=${AWS_REGION}

    if [ "$1" = "versioned-bucket" ]; then
        aws s3api put-bucket-versioning --bucket ${BUCKET_NAME} --versioning-configuration Status=Enabled
    fi
fi

# Create cluster object
# Note: We don't use a config file here as Kops will set a params based on our
#       kubernetes version, etc.
echo "Building cluster"
kops create cluster \
    --zones ${AWS_AZ} \
    --master-zones=ap-southeast-2a,ap-southeast-2b,ap-southeast-2c \
    --ssh-public-key=${KOPS_PUB_KEY} \
    --master-size=t2.small \
    --node-size=t2.small \
    --node-count=3 \
    --admin-access="${NISHI_IP}/32" \
    --ssh-access="${NISHI_IP}/32" \
    --network-cidr="10.10.0.0/16" \
    --topology public \
    --cloud=aws \
    ${NAME}

# Create instance groups
echo "Making Core IGs"
buildInstanceGroup replace Master master-ap-southeast-2a t2.small \"0.05\" 1 1 20
buildInstanceGroup replace Master master-ap-southeast-2b t2.small \"0.05\" 1 1 20
buildInstanceGroup replace Master master-ap-southeast-2c t2.small \"0.05\" 1 1 20
buildInstanceGroup replace Node nodes t2.medium \"0.05\" ${GENERAL_SWARM_MAX_NODES} 1 20

echo "Making General Compute IGs"
buildInstanceGroup create Node gc_m5l m5.large \"0.05\" ${GENERAL_SWARM_MAX_NODES} 0 20
buildInstanceGroup create Node gc_m4l m4.large \"0.05\" ${GENERAL_SWARM_MAX_NODES} 0 20
buildInstanceGroup create Node gc_t2l t2.large \"0.05\" ${GENERAL_SWARM_MAX_NODES} 0 20
buildInstanceGroup create Node gc_m5xl m5.xlarge \"0.08\" ${GENERAL_SWARM_MAX_NODES} 0 20
buildInstanceGroup create Node gc_m4xl m4.xlarge \"0.08\" ${GENERAL_SWARM_MAX_NODES} 0 20
buildInstanceGroup create Node gc_t2xl t2.xlarge \"0.08\" ${GENERAL_SWARM_MAX_NODES} 0 20

echo "Making Memory-optimised IGs"
buildInstanceGroup create Node mo_r4l r4.large \"0.05\" ${MEMORY_SWARM_MAX_NODES} 0 20
buildInstanceGroup create Node mo_r3l r3.large \"0.05\" ${MEMORY_SWARM_MAX_NODES} 0 20
buildInstanceGroup create Node mo_r4xl r4.xlarge \"0.08\" ${MEMORY_SWARM_MAX_NODES} 0 20
buildInstanceGroup create Node mo_r3xl r3.xlarge \"0.08\" ${MEMORY_SWARM_MAX_NODES} 0 20
buildInstanceGroup create Node mo_r42xl r4.2xlarge \"0.15\" ${MEMORY_SWARM_MAX_NODES} 0 20
buildInstanceGroup create Node mo_r32xl r3.2xlarge \"0.15\" ${MEMORY_SWARM_MAX_NODES} 0 20

# Generate a new secret for the cluster
echo "Generating Secret"
kops create secret --name ${NAME} sshpublickey admin -i ${KOPS_PUB_KEY}

# Commit the cluster changes
#echo "Committing Cluster"
kops update cluster ${NAME} --yes