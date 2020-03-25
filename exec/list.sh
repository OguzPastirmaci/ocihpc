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
  list    Lists available packages for deployment
  *         Help
"
  exit 1
}

echo "List of available packages:"
echo ""
echo "$(curl -s https://raw.githubusercontent.com/OguzPastirmaci/ocihpc/master/catalog)"
echo ""