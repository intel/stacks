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

# install impi
echo -e "/opt/intel/mpi/lib/intel64_lin" >> /etc/ld.so.conf \
  && cd "$IMPI_TEMP_ROOT"/"$IMPI_V" \
  && mkdir -p "$INSTALL_ROOT" \
  && ./install.sh -s /workspace/components/impi/impi.config \
  && ldconfig \
  && cleanup $IMPI_TEMP_ROOT || { echo "cleanup failed" ; exit 1; }

