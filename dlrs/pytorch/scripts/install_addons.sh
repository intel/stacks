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

addons=( "pytorch-lightning==1.1.5" "flair==0.7.*" "onnx==1.8.0" )
echo "=================installing pkg dependencies=================="
    wget https://raw.githubusercontent.com/PyTorchLightning/pytorch-lightning/1.1.5/requirements.txt -O requirements.txt \
    && wget https://raw.githubusercontent.com/flairNLP/flair/v0.7/requirements.txt -O - >> requirements.txt \
    && sed -i '/torch/d' requirements.txt \
    && sed -i '/tqdm/d' requirements.txt \
    && sed -i '/transformers>=3.5.0,<=3.5.1/d' requirements.txt \
    && pip install --no-cache-dir \
    -r requirements.txt

CC="cc -mavx2" pip install --no-cache-dir --force-reinstall "pillow-simd==7.0.*"

for pkg in "${addons[@]}"
do
  echo "=================get and install $pkg======================="
  pip install --no-deps --no-cache-dir "$pkg" || { echo "failed installing $pkg"; exit 1; }
  echo "==================done======================================"
done
exit 0
