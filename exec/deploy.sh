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
ZIP_FILE_PATH="$OCIHPC_WORKDIR/downloaded-packages/$PACKAGE/$PACKAGE.zip"
URL="https://github.com/OguzPastirmaci/ocihpc/raw/master/packages/$PACKAGE.zip"

if curl --head --silent --fail $URL > /dev/null;
 then
  echo ""
  echo "Downlading package: $PACKAGE"
  echo ""
  [ ! -d "$OCIHPC_WORKDIR/downloaded-packages/$PACKAGE" ] && mkdir -p "$OCIHPC_WORKDIR/downloaded-packages/$PACKAGE"
  [ ! -f "$ZIP_FILE_PATH" ] && curl -sL $URL -o $OCIHPC_WORKDIR/downloaded-packages/$PACKAGE/$PACKAGE.zip  > /dev/null
 else
  echo ""
  echo "The package $PACKAGE does not exist."
  echo ""
  $OCIHPC_WORKDIR/ocihpc.sh list
  exit
fi

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