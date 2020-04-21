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

export CFLAGS="-mfma -msse -msse2 -msse3 -mssse3 -mcx16 -msahf -mmovbe -msse4.2 -msse4.1 -mlzcnt -mavx -mavx2 -mtune=skylake-avx512 -m64 "
export CXXFLAGS="-mfma -msse -msse2 -msse3 -mssse3 -mcx16 -msahf -mmovbe -msse4.2 -msse4.1 -mlzcnt -mavx -mavx2 -mtune=skylake-avx512 -m64 "
export OPTM=3
export TF_TAG=v1.15.2
export USE_BAZEL_VERSION=0.26.1
export PYTHON_BIN_PATH=/usr/bin/python
export PROJECT=tensorflow
export USE_DEFAULT_PYTHON_LIB_PATH=1
export TF_NEED_JEMALLOC=1
export TF_NEED_KAFKA=0
export TF_NEED_OPENCL_SYCL=0
export TF_NEED_GCP=0
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

run() {
  echo "=============================================================="
  printf "$(date) -- %s"
  printf "%s\n" "$@"
  echo "=============================================================="
}

python_pkgs(){
# install dependencies for tensorflow build
  pip install pip six numpy wheel setuptools mock "future>=0.17.1"
  pip install keras_applications==1.0.8 --no-deps
  pip install keras_preprocessing==1.1.0 --no-deps
}

get_project() {
  git clone --depth 1 -b ${TF_TAG} https://github.com/${PROJECT}/${PROJECT}.git 
  cd tensorflow && git checkout ${TF_TAG}
  apply_patches
}

apply_patches() {
  git config --global user.email "example@example.com"
  git config --global user.name "example@example.com"
  # fix from https://github.com/Meadosc/patches/blob/master/0001-change-reserved-tp_print-slot-from-nullptr-to-0.-Fix.patch
  wget https://raw.githubusercontent.com/clearlinux-pkgs/tensorflow/master/0001-Add-grpc-fix-for-gettid.patch 
  git am 0001-Add-grpc-fix-for-gettid.patch
  # fix from https://github.com/Meadosc/patches/blob/master/0001-change-reserved-tp_print-slot-from-nullptr-to-0.-Fix.patch
  wget https://raw.githubusercontent.com/Meadosc/patches/master/0001-change-reserved-tp_print-slot-from-nullptr-to-0.-Fix.patch
  git am 0001-change-reserved-tp_print-slot-from-nullptr-to-0.-Fix.patch
  # fix from https://github.com/clearlinux-pkgs/tensorflow/blob/master/0001-Fix-TensorFlow-on-Python-3.8-logger-issue.patch
  wget https://raw.githubusercontent.com/clearlinux-pkgs/tensorflow/master/0001-Fix-TensorFlow-on-Python-3.8-logger-issue.patch
  git am 0001-Fix-TensorFlow-on-Python-3.8-logger-issue.patch
}

build () {
  # configure and build tensorflow avx512 version
  # build avx512 TF
  mkdir -p /tmp/tf/avx512
  export ARCH=skylake-avx512
  export TUNE=cascadelake
  export TF_BUILD_MAVX=MAVX512
  export CC_OPT_FLAGS="-march=${ARCH} -mtune=${TUNE}"
  export CFLAGS="$CFLAGS -march=${ARCH}"
  export CXXFLAGS="$CXXFLAGS -march=${ARCH}"
  
  #skx instructions
  #--copt=-mfma --copt=-mavx512f --copt=-mavx512cd\
  #--copt=-mavx512bw --copt=-mavx512vl --copt=-mavx512dq
  #--copt="-DEIGEN_USE_MKL_VML"
  bazel clean && ./configure
  bazel --output_base=/tmp/bazel build  \
  --repository_cache=/tmp/cache  \
  --config=opt --config=mkl \
  --copt=-mfma  --copt=-O${OPTM} \
  --copt=-mtune=${TUNE}  --copt=-march=${ARCH} \
  --copt=-Wa,-mfence-as-lock-add=yes \
  //tensorflow/tools/pip_package:build_pip_package

  # generate pip package
  bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tf/avx512/

  # build avx2 TF	
  mkdir -p /tmp/tf/avx2	
  export ARCH=skylake	
  export TUNE=skylake	
  export TF_BUILD_MAVX=MAVX2	
  export CC_OPT_FLAGS="-march=${ARCH} -mtune=${TUNE}"	
  export CFLAGS="$CFLAGS -march=${ARCH}"	
  export CXXFLAGS="$CXXFLAGS -march=${ARCH}"	

  #skl instructions	
  #--copt=-mavx2	
  # --copt="-DEIGEN_USE_MKL_VML" 	
  #./configure	
  #bazel --output_base=/tmp/bazel build  \
  #--repository_cache=/tmp/cache \	
  #--config=opt --config=mkl \	
  #--copt=-mfma --copt=-O${OPTM} \	
  #--copt=-mtune=${TUNE} --copt=-march=${ARCH} \	
  #--copt=-Wa,-mfence-as-lock-add=yes \	
  #//tensorflow/tools/pip_package:build_pip_package	
  # generate pip package	
  #bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tf/avx2
}

begin="$(date +%s)"
run "get ${PROJECT}" && get_project 
run "install python deps" && python_pkgs
run "config, build ${PROJECT}" && build
finish="$(date +%s)"
runtime=$(((finish-begin)/60))
run "Done in :  $runtime minute(s)"
