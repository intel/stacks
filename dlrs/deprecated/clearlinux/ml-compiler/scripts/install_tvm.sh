#!/bin/bash
#
# Copyright (c) 2020 Intel Corporation
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

# project source details
export PROJECT=incubator-tvm
export PROJECT_ALIAS=tvm
export PROJECT_GIT_URL=https://github.com/apache/${PROJECT}.git
export PROJECT_VERSION=v0.6
export PROJECT_BUILD_DIR="${PROJECT_ALIAS:?}"/build/
export MKL_ROOT=/usr/local/lib/mkl

# build config
export CFLAGS="-O3 -falign-functions=32 -fno-lto -fno-math-errno -fno-semantic-interposition -fno-trapping-math "
export CXXFLAGS="-O3 -falign-functions=32 -fno-lto -fno-math-errno -fno-semantic-interposition -fno-trapping-math "
export FCFLAGS="$CFLAGS "
export FFLAGS="$CFLAGS "
export CFLAGS="$CFLAGS -march=skylake-avx512 -m64 -pipe"
export CXXFLAGS="$CXXFLAGS -march=skylake-avx512 -m64 -pipe"
export GCC_IGNORE_WERROR=1
export N_JOBS=$(grep -c ^processor /proc/cpuinfo)

run()
{
  echo "=============================================================="
  printf "$(date) -- %s"
  printf "%s\n" "$@"
  echo "=============================================================="
}

get_project() {
  # clone the repo
  if [ ! -d ./${PROJECT} ]; then
      git clone --recursive -j"$N_JOBS" ${PROJECT_GIT_URL} ${PROJECT_ALIAS}\
      && cd "./${PROJECT_ALIAS}" && git checkout -b ${PROJECT_VERSION} \
      && cd ..
  fi
}

python_pkgs() {
  pip --no-cache-dir install numpy decorator Jupyter \
                attrs tornado psutil xgboost nose-timer
}

build() {
  # configure and build
  CMAKE_ARGS="-DUSE_LLVM=llvm-config
  -DUSE_BLAS=mkl
  -DUSE_MKL_PATH=${MKL_ROOT}
  -D=GRAPH_RUNTIME=ON
  -D=USE_RPC=ON
  -DUSE_SORT=ON"
  [ -d "${PROJECT_BUILD_DIR}" ] && rm -rf "${PROJECT_BUILD_DIR}"
  mkdir -p ${PROJECT_BUILD_DIR} && cd "${PROJECT_BUILD_DIR}"
  cmake $CMAKE_ARGS ..
  make -j"$N_JOBS"
  echo "${PROJECT_ALIAS} build directory is: ${PROJECT_BUILD_DIR}"
  # install python bindings
  cd ..; cd python; python setup.py install --user; cd ..
  cd topi/python; python setup.py install --user; cd ../..
}

cleanup() {
  # remove unneeded mkl libs and tvm directories
    echo "clean up unneeded files.."
    rm -rf /usr/local/lib/mkl/include /usr/local/lib/mkl/lib/libmklml_intel.so
    cd /tvm; dirs=(*/); needed_dirs=( topi/ nnvm/ vta/ build/ python/ )
    shopt -s dotglob; shopt -s nullglob
    for dir in "${dirs[@]}"
      do 
        if [[ ! ${needed_dirs[*]} =~ ${dir} ]];then echo "Removing:: $dir "; rm -rf "${dir}"; fi
      done
    rm -rf /tvm/build/CMake* /tvm/build/*.cmake /tvm/build/Makefile /tvm/build/*.json \
      .clang-format CMakeLists.txt CONTRIBUTORS.md .git .github .gitignore \
      .gitmodules Jenkinsfile LICENSE Makefile NEWS.md NOTICE
}

begin="$(date +%s)"
run "get ${PROJECT}" && get_project
run "config, build ${PROJECT_ALIAS}" && build
cleanup
run "install python deps" && python_pkgs
finish="$(date +%s)"
runtime=$(((finish-begin)/60))
run "Done in :  $runtime minute(s)"
