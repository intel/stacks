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

# install Intel Parallel studio
cd "$IPS_TEMP_ROOT"/"$IPS_V" \
  && mkdir -p "$INSTALL_ROOT" \
  && ./install.sh --silent /workspace/components/ips/ips.config \
  && cleanup $IPS_TEMP_ROOT || { echo "cleanup failed" ; exit 1; } \
