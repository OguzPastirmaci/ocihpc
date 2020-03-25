#!/bin/bash

set -e
export OCIHPC_WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
source "$OCIHPC_WORKDIR/common/util.sh"

usage() {
  cli_name=${0##*/}
  echo "
Oracle Cloud Infrastructure Easy HPC Deploy

Usage: $cli_name [command]

Commands:
  create    Create a deployment
  *         Help
"
  exit 1
}

export PACKAGE=$1
ZIP_FILE_PATH="$OCIHPC_WORKDIR/packages/$PACKAGE.zip"
echo ""
echo "Downlading package: $PACKAGE"
echo ""
 [ ! -d "$OCIHPC_WORKDIR/packages" ] && mkdir "$OCIHPC_WORKDIR/packages"
 cd $OCIHPC_WORKDIR/packages
 [ ! -f "$ZIP_FILE_PATH" ] && wget -q -N https://github.com/OguzPastirmaci/ocihpc/raw/master/$PACKAGE.zip

echo "Creating stack: $PACKAGE"
echo ""
CREATED_STACK_ID=$(oci resource-manager stack create --compartment-id $COMPARTMENT_ID --display-name ${PACKAGE}-easydeploy-stack --config-source $ZIP_FILE_PATH --query 'data.id' --raw-output)
echo "Created stack id: ${CREATED_STACK_ID}"
echo ""

echo "Creating Plan Job"
echo ""
CREATED_PLAN_JOB_ID=$(oci resource-manager job create-plan-job --stack-id $CREATED_STACK_ID --query 'data.id' --raw-output)
echo "Created Plan Job Id: ${CREATED_PLAN_JOB_ID}"
echo ""