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

export TF_BRANCH=master
BAZEL_MIN_VERSION=$(curl -s  https://raw.githubusercontent.com/tensorflow/tensorflow/"$TF_BRANCH"/configure.py | awk '/_TF_MIN_BAZEL_VERSION =/{print $3}')
if [ -z "$BAZEL_MIN_VERSION" ]; then export BAZEL_VERSION=0.25.2; else export BAZEL_VERSION="${BAZEL_MIN_VERSION//\'}"; fi
echo "TensorFlow tag used for bazel auto selection is ${TF_BRANCH}"
# temp fix for bazel too recent error from TF
export BAZEL_VERSION=0.26.1
echo "BAZEL version is ${BAZEL_VERSION}"
# download and install bazel
mkdir /bazel && cd /bazel 
curl -fSsL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-dist.zip
unzip bazel-"$BAZEL_VERSION"-dist.zip

env EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash ./compile.sh
cp output/bazel /usr/bin/
