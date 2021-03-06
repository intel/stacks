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

if [[ "$1" == "tf2" ]]; then
  TFS_API_VER='2.4.*'
else
  TFS_API_VER='1.15.*'
fi

addons=("tensorflow-datasets==4.2.*" "transformers==4.2.*")

echo "=================installing frameworks=================="
  pip install --force jupyterlab
  pip install --no-cache-dir -r /workspace/pypkgs.txt
  pip install --no-cache-dir --no-deps tensorflow-serving-api==${TFS_API_VER}

echo "=================installing pkg dependencies=================="

# pillow need libjpeg
CC="cc -mavx2" pip install --no-cache-dir --force-reinstall "Pillow-SIMD==7.0.0.post3"

for pkg in "${addons[@]}"
do
  echo "=================get and install $pkg======================="
  pip install --no-deps --no-cache-dir "$pkg" || { echo "failed installing $pkg"; exit 1; }
  echo "==================done======================================"
done
exit 0
