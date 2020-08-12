#!/usr/bin/env bash

set -e

# import required scripts
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/../config_vars.sh"

# init
script_name=`basename "$0"`
echo "executing script ::  $script_name"

# install horovod
pip --no-cache-dir install "horovod[pytorch]==$HVD_VER"
