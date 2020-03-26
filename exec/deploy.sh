#!/bin/bash

set -e

export OCIHPC_WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
export PACKAGE=$1

ZIP_FILE_PATH="$OCIHPC_WORKDIR/downloaded-packages/$PACKAGE/$PACKAGE.zip"
CONFIG_FILE_PATH="$OCIHPC_WORKDIR/downloaded-packages/$PACKAGE/config.json"

source "$OCIHPC_WORKDIR/common/util.sh"

usage() {
  cli_name=${0##*/}
  echo "
Oracle Cloud Infrastructure Easy HPC Deploy

Usage: $cli_name [command]

Commands:
  deploy    Create a deployment
"
  exit 1
}

echo ""
echo "Creating stack: $PACKAGE"
echo ""
CREATED_STACK_ID=$(oci resource-manager stack create --display-name "${PACKAGE}-EasyDeploy" --config-source $ZIP_FILE_PATH --from-json file://$CONFIG_FILE_PATH --query 'data.id' --raw-output)
echo "Created stack id: ${CREATED_STACK_ID}"
echo "STACK_ID=${CREATED_STACK_ID}" > $OCIHPC_WORKDIR/downloaded-packages/$PACKAGE/.info
echo ""
echo "Creating Plan Job"
echo ""
CREATED_PLAN_JOB_ID=$(oci resource-manager job create-plan-job --stack-id $CREATED_STACK_ID --query 'data.id' --raw-output)
echo ""
echo "Created Plan Job id: ${CREATED_PLAN_JOB_ID}"
echo ""
echo "Waiting for job to complete..."
echo ""

while ! [[ $JOB_STATUS =~ ^(SUCCEEDED|FAILED) ]]
do
sleep 5
JOB_STATUS=$(oci resource-manager job get --job-id ${CREATED_PLAN_JOB_ID} --query 'data."lifecycle-state"' --raw-output)
done

echo "Job has $(oci resource-manager job get --job-id ${CREATED_PLAN_JOB_ID} --query 'data."lifecycle-state"' --raw-output)"