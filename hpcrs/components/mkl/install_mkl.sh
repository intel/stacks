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

# install mkl
echo -e "/opt/intel/mkl/lib/intel64_lin\n/opt/intel/lib/intel64_lin" >> /etc/ld.so.conf \
  && cd "$MKL_TEMP_ROOT"/"$MKL_V" \
  && mkdir -p "$INSTALL_ROOT" \
  && ./install.sh -s /workspace/components/mkl/mkl.config \
  && ldconfig \
  && cleanup $MKL_TEMP_ROOT || { echo "cleanup failed" ; exit 1; }

