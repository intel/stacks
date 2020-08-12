#!/usr/bin/env bash

set -e

# import required scripts
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/../config_vars.sh"
source "$DIR/../utils.sh"

# init
script_name=`basename "$0"`
echo "executing script ::  $script_name"

# vars
IPS_TEMP_ROOT="$TEMP_ROOT/ips"
IPS_TAR="$IPS_TEMP_ROOT"/"$IPS_V.tgz"
IPS_URL="$URL/$IPS_DIR_NR/$IPS_V.tgz"

# download, extract mkl
download $IPS_URL $IPS_TEMP_ROOT 
extract "$IPS_TAR" "$IPS_TEMP_ROOT" 

