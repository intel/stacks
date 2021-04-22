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
	FBGEMM=0
else
	ARCH=skylake-avx512
	TUNE=cascadelake
	FBGEMM=1
fi

export TCH_TAG=v1.8.0-rc2 # Pytorch branch
export VISION_TAG=master    # Torchvision tag
export CFLAGS="-O3 -mfma -mtune=$TUNE -march=$ARCH"
export CXXFLAGS="-O3 -mfma -mtune=$TUNE -march=$ARCH"
export USE_FBGEMM=$FBGEMM
export GCC_IGNORE_WERROR=1

echo "torch version: $TCH_TAG"
echo "torchvision version: $VISION_TAG"
echo "building for: $ARCH"
echo "tuning for: $TUNE"
echo "fbgemm for int8: $FBGEMM"

#wget https://github.com/hongzhen1/pytorch/commit/3511d7f6bd2060e20cf77b770ae32ff538700f37.diff -O dataloader.diff
echo "=================clone pytorch============================="
mkdir /torch-wheels
git clone https://github.com/pytorch/pytorch.git /buildir/pytorch \
    && cd /buildir/pytorch && git checkout ${TCH_TAG} \
    && python setup.py clean \
    && git submodule sync && git submodule update --init --recursive \
    && git apply /buildir/dataloader.patch_v1.8.0-rc2 \
    && sed -i 's#^  ${CMAKE_CURRENT_SOURCE_DIR}/tensor_iterator_test.cpp##g' aten/src/ATen/test/CMakeLists.txt
    #&& rm -rf caffe2/opt/onnxifi_op.* \
#    && cd third_party/ideep/ && git checkout master && git pull && git checkout pytorch_dnnl_dev && cd ../../ \
#    && git add third_party/ideep && git submodule sync &&  git submodule update --init --recursive \
echo "==================done=========================================="

echo "=================clone torchvison============================="
git clone -b ${VISION_TAG} https://github.com/pytorch/vision.git /buildir/vision
echo "==================done=========================================="
