#!/bin/bash

install_ocicli(){
    curl https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh --output ~/install.sh
    chmod +x ~/install.sh
    bash -c ~/install.sh --accept-all-defaults
}

zip_edit(){
    echo "Usage: zipedit archive.zip file.txt"
    unzip "$1" "$2" -d /tmp 
    vi /tmp/$2 && zip -j --update "$1"  "/tmp/$2" 
}

parse_yaml() {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

cli_log() {
  script_name=${0##*/}
  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  echo "== $script_name $timestamp $1"
}

export_config() {
   OCI_USER_ID=""
   OCI_TENANCY_ID=""
   OCI_FINGERPRINT=""
   OCI_REGION=""
   OCI_KEY_FILE=""
}