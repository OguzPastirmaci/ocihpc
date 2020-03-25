#!/bin/bash

set -ex
export OCIHPC_WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
source "$OCIHPC_WORKDIR/common/util.sh"
export PACKAGE=$1


usage() {
  cli_name=${0##*/}
  echo "
Oracle Cloud Infrastructure Easy HPC Deploy

Usage: $cli_name [command]

Commands:
  delete    Delete a deployment
"
  exit 1
}

STACK_ID=$(cat $OCIHPC_WORKDIR/downloaded-packages/$PACKAGE/.stack.info | cut -d' ' -f2)

echo "Creating Destroy Job"
CREATED_DESTROY_JOB_ID=$(oci resource-manager job create-destroy-job --stack-id $STACK_ID --execution-plan-strategy=AUTO_APPROVED --wait-for-state SUCCEEDED --wait-for-state FAILED --query 'data.id' --raw-output)
echo "Created Destroy Job Id: ${CREATED_DESTROY_JOB_ID}"

echo "Deleting Stack"
oci resource-manager stack delete --stack-id $STACK_ID --force
echo "Deleted Stack Id: $STACK_ID"
