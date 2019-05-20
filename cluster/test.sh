#!/usr/bin/env bash

. ../common/coreConfig.sh

# Create S3 bucket
if ! aws s3api head-bucket --bucket "foobar-test348" 2>/dev/null; then
    echo "Found bucket"
else
    echo "Didn't find bucket"
fi

