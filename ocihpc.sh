#!/bin/bash
export OCIHPC_WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export COMPARTMENT_ID="ocid1.compartment.oc1..aaaaaaaafxezajxlyjxkh23ux75iqttja2qvdded3fc3v5h4kth6zvhnus3q"

source "$OCIHPC_WORKDIR/common/util.sh"

usage() {
  cli_name=${0##*/}
  echo "
Oracle Cloud Infrastructure Easy HPC Deploy

Usage: $cli_name [command]

Commands:
  deploy    Deploy an HPC solution
  delete    Delete a deployed HPC solution
  list      List available solutions for deployment
"
  exit 1
}

case "$1" in
  deploy)
    "$OCIHPC_WORKDIR/exec/deploy.sh" "$2" | tee -ia "$OCIHPC_WORKDIR/deploy_${2}.log"
    ;;
  delete)
    "$OCIHPC_WORKDIR/exec/delete.sh" "$2" | tee -ia "$OCIHPC_WORKDIR/delete${2}.log"
    ;;
  list)
    "$OCIHPC_WORKDIR/exec/list.sh" "$2" | tee -ia "$OCIHPC_WORKDIR/list_${2}.log"
    ;;  
  *)
    usage
    ;;
esac