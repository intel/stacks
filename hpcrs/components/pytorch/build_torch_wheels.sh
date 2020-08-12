#!/usr/bin/env bash

set -e

# import required scripts
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/../config_vars.sh"

# init
script_name=`basename "$0"`
echo "executing script ::  $script_name"

export BUILD_ONNX_PYTHON=$BUILD_ONNX_PYTHON
export USE_FBGEMM=$USE_FBGEMM
export BUILD_TESTS=$BUILD_TESTS
export USE_OPENCV=0

echo "=================build pytorch============================="
pip install --no-cache-dir numpy ninja pyyaml setuptools cffi wheel

# if mkl is installed already, the below pip install is not required
pip install --no-cache-dir mkl mkl-include
# instead uncomment this line
#source $INSTALL_ROOT/bin/compilervars.sh $ARCH
cd /tmp/pytorch \
  && rm -rf caffe2/opt/onnxifi_op.* \
  && sed -i 's#^  ${CMAKE_CURRENT_SOURCE_DIR}/tensor_iterator_test.cpp##g' aten/src/ATen/test/CMakeLists.txt \
  && python setup.py bdist_wheel -d /torch-wheels;

pip --no-cache-dir install /torch-wheels/*
