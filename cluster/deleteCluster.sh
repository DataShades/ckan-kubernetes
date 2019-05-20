#!/usr/bin/env bash

. ../common/coreConfig.sh

././../autoscale/teardown.sh
././../efs/teardown.sh

kops delete cluster ${NAME} --yes

if [ "$1" = "delete-bucket" ]; then
    # Only needed if we are using a version bucket
    ./deleteS3Bucket.sh ${BUCKET_NAME}

    aws s3api delete-bucket --bucket ${BUCKET_NAME} --region ${AWS_REGION}
fi

rm ${KOPS_PUB_KEY_PARAM}*