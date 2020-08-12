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
IMPI_TEMP_ROOT="$TEMP_ROOT/impi"
IMPI_TAR="$IMPI_TEMP_ROOT"/"$IMPI_V.tgz"
IMPI_URL="$URL/$IMPI_DIR_NR/$IMPI_V.tgz"

# download, extract mkl
download $IMPI_URL $IMPI_TEMP_ROOT \
  && extract "$IMPI_TAR" "$IMPI_TEMP_ROOT" 

