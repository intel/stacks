#!/bin/bash
#
# Copyright (c) 2018 Intel Corporation
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

run() {
  echo "=============================================================="
  printf "$(date) -- %s"
  printf "%s\n" "$@"
  echo "=============================================================="
}

install_dl_libs() {
  pip --no-cache-dir install \
    tensorflow==1.15.0 torch \
    torchvision onnx future \
    keras cython scipy Image Pillow \
    && rm -rf /tmp/* \
    && find /usr/lib/ -follow -type f -name '*.pyc' -delete \
    && find /usr/lib/ -follow -type f -name '*.js.map' -delete 
  }

begin="$(date +%s)"
run "install DL frameworks" && install_dl_libs
finish="$(date +%s)"
runtime=$(((finish-begin)/60))
run "Done in :  $runtime minute(s)"
