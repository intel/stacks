#!/bin/bash
#
# Copyright (c) 2019 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
set -e
set -u
set -o pipefail

export MKL_VERSION=mklml_lnx_2019.0.5.20190502
export MKLDNN=v0.19
export MKL_ROOT=/usr/local/lib/mkl
export CFLAGS="-O3 -falign-functions=32 -fno-lto -fno-math-errno -fno-semantic-interposition -fno-trapping-math "
export CXXFLAGS="-O3 -falign-functions=32 -fno-lto -fno-math-errno -fno-semantic-interposition -fno-trapping-math "
export FCFLAGS="$CFLAGS "
export FFLAGS="$CFLAGS "
export CFLAGS="$CFLAGS -march=skylake-avx512 -m64 -pipe"
export CXXFLAGS="$CXXFLAGS -march=skylake-avx512 -m64 -pipe"
export GCC_IGNORE_WERROR=1

run()
{
  echo "=============================================================="
  printf "$(date) -- %s"
  printf "%s\n" "$@"
  echo "=============================================================="
}

install_mkl()
{
  if [ ! -d ${MKL_ROOT} ]; then
    mkdir -p ${MKL_ROOT} \
    && wget https://github.com/intel/mkl-dnn/releases/download/"$MKLDNN"/"$MKL_VERSION".tgz \
    && tar -xzf "$MKL_VERSION".tgz -C ${MKL_ROOT} \
      && mv "${MKL_ROOT:?}"/"${MKL_VERSION:?}"/* ${MKL_ROOT} \
      && rm -rf "${MKL_ROOT:?}"/"${MKL_VERSION:?}" \
      && rm "${MKL_VERSION}.tgz"
  fi
  echo "MKL libs are in directory: ${MKL_ROOT}"
}

start="$(date +%s)"
run "Install mkl" && install_mkl
end="$(date +%s)"
runtime=$(((end-start)/60))
run "Done in :  $runtime minute(s)"
