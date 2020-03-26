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
URL="https://github.com/OguzPastirmaci/ocihpc/raw/master/packages/$PACKAGE/$PACKAGE.zip"

if curl --head --silent --fail $URL > /dev/null;
 then
  echo ""
  echo "Downlading package: $PACKAGE"
  echo ""
  [ ! -d "$OCIHPC_WORKDIR/downloaded-packages/$PACKAGE" ] && mkdir -p "$OCIHPC_WORKDIR/downloaded-packages/$PACKAGE"
  [ ! -f "$ZIP_FILE_PATH" ] && curl -sL $URL/$PACKAGE.zip -o $OCIHPC_WORKDIR/downloaded-packages/$PACKAGE/$PACKAGE.zip  > /dev/null
  [ ! -f "$CONFIG_FILE_PATH" ] && curl -sL $URL/config.json -o $OCIHPC_WORKDIR/downloaded-packages/$PACKAGE/config.json  > /dev/null
 else
  echo ""
  echo "The package $PACKAGE does not exist."
  echo ""
  $OCIHPC_WORKDIR/ocihpc.sh list
  exit
fi