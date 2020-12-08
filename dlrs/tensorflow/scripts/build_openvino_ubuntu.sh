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

export N_JOBS=$(grep -c ^processor /proc/cpuinfo)

export CFLAGS="-O3 "
export CXXFLAGS="-O3 "
export FCFLAGS="$CFLAGS "
export FFLAGS="$CFLAGS "
export CFLAGS="$CFLAGS -mfma -mcx16 -msahf -mmovbe -mlzcnt -mavx -mtune=skylake-avx512 -m64"
export CXXFLAGS="$CXXFLAGS -mfma -mcx16 -msahf -mmovbe -mlzcnt -mtune=skylake-avx512 -m64"
export GCC_IGNORE_WERROR=1
export CMAKE_CXX_FLAGS="Wno-error=deprecated-declarations -Wno-error=redundant-move -Wno-error=pessimizing-move -Wno-error=unused-function -Wno-error=parentheses"

echo "================= applying patches ========================="
git config --global user.email "example@example.com"
git config --global user.name "example@example.com"

echo "================= config and build IE bridges ========================="
mkdir -p /dldt/build && cd /dldt/build
IE_BUILD_DIR=$(pwd)
CMAKE_ARGS="-DTREAT_WARNING_AS_ERROR=OFF"
CMAKE_ARGS="$CMAKE_ARGS OpenCV_DIR=/usr/lib/x86_64-linux-gnu/cmake/opencv4/ -DENABLE_OPENCV=OFF"
CMAKE_ARGS="$CMAKE_ARGS -DENABLE_MKL_DNN=ON -DTHREADING=TBB -DENABLE_GNA=ON -DENABLE_CLDNN=ON -DENABLE_MYRIAD=OFF -DENABLE_VPU=OFF"
CMAKE_ARGS="$CMAKE_ARGS -DENABLE_PYTHON=ON -DPYTHON_EXECUTABLE=$(command -v python) -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.8.so -DPYTHON_INCLUDE_DIR=/usr/include/python3.8"
cmake $CMAKE_ARGS ..
make -j "$N_JOBS"

echo "===================================================================="
PYTHON_MODULE="inference-engine/bin/intel64/Release"
echo "Inference Engine build directory is: $IE_BUILD_DIR"
echo "IE bridges build directory is: $PYTHON_MODULE"
echo "===================================================================="
