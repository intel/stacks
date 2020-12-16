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
set -o pipefail

if [[ "$1" == "skylake" ]];
then
	ARCH=skylake
	TUNE=skylake
else
	ARCH=skylake-avx512
	TUNE=cascadelake
fi

export GIT_BRANCH=v1.7.0 # Pytorch branch
export GIT_TAG=v0.8.1    # Torchvision tag
export CFLAGS="-O3 -mfma -mtune=$TUNE" # -march=$ARCH"
export CXXFLAGS="-O3 -mfma -mtune=$TUNE" # -march=$ARCH"
export GCC_IGNORE_WERROR=1
export GIT_SSL_NO_VERIFY=1

echo "torch version: $GIT_BRANCH"
echo "torchvision version: $GIT_TAG"
echo "building for: $ARCH"
echo "tuning for: $TUNE"

echo "=================clone pytorch============================="
mkdir -p /torch-wheels
git clone https://github.com/pytorch/pytorch.git /workspace/pytorch \
    && cd /workspace/pytorch && git checkout $GIT_BRANCH \
    && git submodule sync && git submodule update --init --recursive
echo "==================done=========================================="
