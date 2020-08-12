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
MKL_TEMP_ROOT="$TEMP_ROOT/mkl"
MKL_TAR="$MKL_TEMP_ROOT"/"$MKL_V.tgz"
MKL_URL="$URL/$MKL_DIR_NR/$MKL_V.tgz"

# download, extract mkl
download $MKL_URL $MKL_TEMP_ROOT \
  && extract "$MKL_TAR" "$MKL_TEMP_ROOT" 

