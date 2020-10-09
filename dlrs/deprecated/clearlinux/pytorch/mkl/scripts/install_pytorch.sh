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

export PATH=/opt/conda/bin/:$PATH
export GCC_IGNORE_WERROR=1
# build servers are skylake-avx512; would be built for the arch with `native`
export CFLAGS="$CFLAGS -O3 -mfma -mtune=skylake-avx512 -march=native"
export CXXFLAGS="$CXXFLAGS -O3 -mfma -mtune=skylake-avx512 -march=native"
export GIT_BRANCH=v1.3.1
export CMAKE_PREFIX_PATH=/opt/conda
# build failing when FBGEMM is enabled, disabling until fix is found
export USE_FBGEMM=0
# linker fix
[ -f /opt/conda/compiler_compat/ld ] && mv /opt/conda/compiler_compat/ld /opt/conda/compiler_compat/ld.org
echo "=================get pytorch================================="
if [ ! -d ./pytorch/ ]; then
    git clone --recurse-submodules -j15 https://github.com/pytorch/pytorch.git \
    && cd pytorch && git checkout $GIT_BRANCH \
    && cd ..
fi
echo "=================build and install pytorch with MKL============="
rm -rf pytorch/caffe2/opt/onnxifi_op.*
cd ./pytorch/
/opt/conda/bin/pip --no-cache-dir install pyyaml
# Workaround for https://github.com/pytorch/pytorch/issues/26555
sed -i 's#^  ${CMAKE_CURRENT_SOURCE_DIR}/tensor_iterator_test.cpp##g' aten/src/ATen/test/CMakeLists.txt \
  && python setup.py build && python setup.py install \
  && cd / && rm -rf /scripts/pytorch \
  && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
  && find /opt/conda/ -follow -type f -name '*.pyc' -delete
echo "======================done======================================"
