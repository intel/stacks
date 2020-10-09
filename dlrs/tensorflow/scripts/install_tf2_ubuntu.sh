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

# default copts
COPT="--config=opt --copt=-O3 --config=v2 --config=mkl --copt=-Wa,-mfence-as-lock-add=yes"

if [[ "$1" == "skylake" ]]; then

    export TF_TAG="2b8c0b1"
    export NAMESPACE=tensorflow
    export ARCH="skylake"
    export TUNE="skylake"
    export TF_BUILD_MAVX=MAVX2
    COPT+=" --copt=-mtune=${TUNE} --copt=-march=${ARCH}"

elif [[ "$1" == "cooperlake" ]]; then

    export TF_TAG="bf16/base"
    export NAMESPACE="Intel-tensorflow"
    export ARCH="skylake-avx512"
    export TUNE="cascadelake"
    export TF_BUILD_MAVX=MAVX512
    COPT+=" --copt=-mtune=${TUNE} --copt=-march=${ARCH}"
    COPT+=" --define build_with_mkl_dnn_v1_only=true --copt=-DENABLE_INTEL_MKL_BFLOAT16"
else

    export TF_TAG="2b8c0b1"
    export NAMESPACE=tensorflow
    export ARCH="skylake-avx512"
    export TUNE="cascadelake"
    export TF_BUILD_MAVX=MAVX512
    COPT+=" --copt=-mtune=${TUNE} --copt=-march=${ARCH}"

fi

export CC_OPT_FLAGS="-march=${ARCH} -mtune=${TUNE}"
export CFLAGS="-mfma -mcx16 -msahf -mmovbe -mlzcnt -march=$ARCH -mtune=$TUNE -m64 "
export CXXFLAGS="-mfma -mcx16 -msahf -mmovbe -mlzcnt -march=$ARCH -mtune=$TUNE -m64 "
export PYTHON_BIN_PATH=/usr/bin/python
export PROJECT=tensorflow
export USE_DEFAULT_PYTHON_LIB_PATH=1
export TF_NEED_JEMALLOC=1
export TF_NEED_KAFKA=0
export TF_NEED_OPENCL_SYCL=0
export TF_NEED_GCP=0
export TF_NEED_AWS=0
export TF_NEED_HDFS=0
export TF_NEED_S3=0
export TF_ENABLE_XLA=1
export TF_NEED_GDR=0
export TF_NEED_VERBS=0
export TF_NEED_OPENCL=0
export TF_NEED_MPI=0
export TF_NEED_TENSORRT=0
export TF_SET_ANDROID_WORKSPACE=0
export TF_DOWNLOAD_CLANG=0
export TF_NEED_CUDA=0
export HTTP_PROXY=$(echo "$http_proxy" | sed -e 's/\/$//')
export HTTPS_PROXY=$(echo "$https_proxy" | sed -e 's/\/$//')
N_CORES=`getconf _NPROCESSORS_ONLN`
N_JOBS=`echo "$N_CORES * 1.8 / 1" | bc`

run() {
  echo "=============================================================="
  printf "$(date) -- %s"
  echo "building tensorflow"
  echo "with cpu arch: $ARCH"
  echo "with cpu tune: $TUNE"
  echo "AVX setting: $TF_BUILD_MAVX"
  printf "%s\n" "$@"
  echo "=============================================================="
}

python_pkgs(){
# install dependencies for tensorflow build
  pip install pip six wheel "numpy<1.19.0,>=1.16.0" setuptools mock "future>=0.17.1"
  pip install keras_applications==1.0.8 --no-deps
  pip install keras_preprocessing==1.1.0 --no-deps
}

get_project() {
  git clone https://github.com/${NAMESPACE}/${PROJECT}.git 
  cd $PROJECT && git checkout ${TF_TAG}
}

apply_patch() {
	# apply patches/fixes to TF
	# git default config
	git config --global user.email "example@example.com"
	git config --global user.name "example@example.com"
  
}

build () {
  bazel clean && ./configure
  bazel --output_base=/tmp/bazel build  \
  --jobs "$N_JOBS" \
  --repository_cache=/tmp/cache  $COPT \
   //tensorflow/tools/pip_package:build_pip_package
  
  # generate pip package
  
  if [[ "$ARCH" == "skylake" ]]; then
    PIP_DIR="/tmp/tf/avx2"
  else
   PIP_DIR="/tmp/tf/avx512"
  fi
  mkdir -p "$PIP_DIR"
  
  bazel-bin/tensorflow/tools/pip_package/build_pip_package "$PIP_DIR"
}

begin="$(date +%s)"
run "get ${PROJECT}" && get_project 
#run "apply patches for CVEs" && apply_patch
run "install python deps" && python_pkgs
run "config, build ${PROJECT}" && build
finish="$(date +%s)"
runtime=$(((finish-begin)/60))
run "Done in :  $runtime minute(s)"
