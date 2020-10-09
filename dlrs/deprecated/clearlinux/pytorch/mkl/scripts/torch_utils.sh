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

export GIT_BRANCH=v1.4.0 # Pytorch branch
export GIT_TAG=v0.5.0    # Torchvision tag

echo "=================install torch dependencies============================="
    pip --no-cache-dir install \
    cmake numpy \
    ninja pyyaml \
    mkl mkl-include \
    setuptools cffi \
    typing wheel
echo "==================done=========================================="

echo "=================clone pytorch============================="
git clone --recurse-submodules -j15 https://github.com/pytorch/pytorch.git /buildir/pytorch --branch ${GIT_BRANCH} \
    && cd /buildir/pytorch && mkdir /torch-wheels \
    && rm -rf caffe2/opt/onnxifi_op.* \
    && sed -i 's#^  ${CMAKE_CURRENT_SOURCE_DIR}/tensor_iterator_test.cpp##g' aten/src/ATen/test/CMakeLists.txt \
    && python setup.py bdist_wheel -d /torch-wheels && python setup.py install
echo "==================done=========================================="

echo "=================clone torchvison============================="
git clone https://github.com/pytorch/vision.git /buildir/vision \
    && cd /buildir/vision && git checkout ${GIT_TAG}
echo "==================done=========================================="

# Workaround for missing libs
ldconfig
