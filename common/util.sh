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

ZIP_FILE_PATH="$OCIHPC_WORKDIR/packages/$PACKAGE.zip"

download_package(){
  echo "Downlading package: $PACKAGE"
 [ ! -d "$OCIHPC_WORKDIR/packages" ] && mkdir "$OCIHPC_WORKDIR/packages"
 cd $OCIHPC_WORKDIR/packages
 [ ! -f "$ZIP_FILE_PATH" ] && wget -q -N https://github.com/OguzPastirmaci/ocihpc/blob/master/$PACKAGE.zip
}

create_stack(){
  echo "Creating stack: $PACKAGE"
  CREATED_STACK_ID=$(oci resource-manager stack create --compartment-id $COMPARTMENT_ID --config-source $ZIP_FILE_PATH --query 'data.id' --raw-output)
  echo "Created stack id: ${CREATED_STACK_ID}"
}

validate_url(){
  if [[ `wget -S --spider $1  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then echo "true"; fi
}