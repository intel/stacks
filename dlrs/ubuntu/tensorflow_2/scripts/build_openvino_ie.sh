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

export CFLAGS="-O3 "
export CXXFLAGS="-O3 "
export FCFLAGS="$CFLAGS "
export FFLAGS="$CFLAGS "
export CFLAGS="$CFLAGS -mfma -msse -msse2 -msse3 -mssse3 -mcx16 -msahf -mmovbe -msse4.2 -msse4.1 -mlzcnt -mavx -mavx2 -march=skylake -mtune=skylake-avx512 -m64"
export CXXFLAGS="$CXXFLAGS -mfma -msse -msse2 -msse3 -mssse3 -mcx16 -msahf -mmovbe -msse4.2 -msse4.1 -mlzcnt -mavx -mavx2 -march=skylake -mtune=skylake-avx512 -m64"
export GCC_IGNORE_WERROR=1

#export GIT_HASH=0ef928  # 2019_R1.0.1
#export GIT_HASH=ba6e22b  # 2019_R2
#export GIT_HASH=1c794d9  # 2019_R3
#export GIT_HASH=fe3f978   # 2019_R3.1
export GIT_HASH=b2140c0 # 2020.1
export N_JOBS=$(grep -c ^processor /proc/cpuinfo)

echo "=================get dldt================================="
if [ ! -d ./dldt/ ]; then
    git clone -j"$N_JOBS" https://github.com/opencv/dldt.git &&\
    cd dldt && git checkout -b v2020.1 $GIT_HASH &&\
    git submodule update --init --recursive && cd ..
fi
echo "=================config and build inference engine=================="
# install inference engine python bridge dependency
pip install opencv-python numpy cython progress
cd ./dldt/

git config --global user.email "example@example.com"
git config --global user.name "example@example.com"
cd inference-engine/thirdparty/ade
git am /patches/ade_gcc9_tmp_fix.patch
cd ../../../
git am /patches/openvino_gcc9_fix.patch

echo "=================config and build IE bridges========================="
CMAKE_ARGS="OpenCV_DIR=/usr/lib64/cmake/opencv4 -DENABLE_OPENCV=OFF -DENABLE_MKL_DNN=ON -DTHREADING=TBB -DENABLE_GNA=ON -DENABLE_CLDNN=ON -DENABLE_MYRIAD=OFF -DENABLE_VPU=OFF -DENABLE_PYTHON=ON -DPYTHON_EXECUTABLE=$(command -v python) -DPYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.8.so -DPYTHON_INCLUDE_DIR=/usr/include/python3.8"
mkdir -p ./build &&\
cd ./build
IE_BUILD_DIR=$(pwd)
cmake $CMAKE_ARGS ..
make -j"$N_JOBS"
echo "===================================================================="
PYTHON_MODULE="inference-engine/bin/intel64/Release"
echo "Inference Engine build directory is: $IE_BUILD_DIR"
echo "IE bridges build directory is: $PYTHON_MODULE"
echo "===================================================================="
