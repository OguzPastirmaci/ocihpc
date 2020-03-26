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
  init    Initializes the package for deployment
  *         Help
"
  exit 1
}

export PACKAGE=$1
ZIP_FILE_PATH="$OCIHPC_WORKDIR/downloaded-packages/$PACKAGE/$PACKAGE.zip"
CONFIG_FILE_PATH="OCIHPC_WORKDIR/downloaded-packages/$PACKAGE/config.json"
ZIP_FILE_URL="https://github.com/OguzPastirmaci/ocihpc/raw/master/packages/$PACKAGE/$PACKAGE.zip"
CONFIG_FILE_URL="https://raw.githubusercontent.com/OguzPastirmaci/ocihpc/master/packages/$PACKAGE/config.json"

if curl --head --silent --fail $ZIP_FILE_URL > /dev/null;
 then
  echo ""
  echo "Downlading package: $PACKAGE"
  echo ""
  [ ! -d "$OCIHPC_WORKDIR/downloaded-packages/$PACKAGE" ] && mkdir -p "$OCIHPC_WORKDIR/downloaded-packages/$PACKAGE"
  [ ! -f "$ZIP_FILE_PATH" ] && curl -sL $ZIP_FILE_URL -o $OCIHPC_WORKDIR/downloaded-packages/$PACKAGE/$PACKAGE.zip  > /dev/null
  [ ! -f "$CONFIG_FILE_PATH" ] && curl -sL $CONFIG_FILE_URL -o $OCIHPC_WORKDIR/downloaded-packages/$PACKAGE/config.json  > /dev/null
  echo "Package $PACKAGE downloaded to $OCIHPC_WORKDIR/downloaded-packages/$PACKAGE"
  echo ""
 else
  echo ""
  echo "The package $PACKAGE does not exist."
  echo ""
  $OCIHPC_WORKDIR/ocihpc.sh list
  exit
fi