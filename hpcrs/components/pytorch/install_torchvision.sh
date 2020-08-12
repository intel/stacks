#!/usr/bin/env bash

set -e

# import required scripts
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/../config_vars.sh"

# init
script_name=`basename "$0"`
echo "executing script ::  $script_name"

echo "=================Install Torchvision============================="
pip install --no-cache-dir --no-deps "torchvision<$TORCHVISION_VER"
