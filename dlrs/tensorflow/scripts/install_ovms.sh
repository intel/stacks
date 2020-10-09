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

MODEL_SERVER_TAG=v2020.3
OVMS_PATH='/ie_serving_py/model_server'

# ---- Get OVMS ----
git clone --depth 1 -b ${MODEL_SERVER_TAG} https://github.com/openvinotoolkit/model_server.git ${OVMS_PATH}
cd ${OVMS_PATH} && git checkout ${MODEL_SERVER_TAG} && cd ..

# ---- OVMS setup ----
echo "OpenVINO Model Server version: ${MODEL_SERVER_TAG}" > /ie_serving_py/version
echo "Git commit: `cd ./model_server; git rev-parse HEAD; cd ..`" >> /ie_serving_py/version
echo "OpenVINO version: ${MODEL_SERVER_TAG} src" >> /ie_serving_py/version
echo "# OpenVINO built with: https://github.com/opencv/dldt.git" >> /ie_serving_py/version

cp -r ./model_server/ie_serving /ie_serving_py/ie_serving
sed -i 29,32d ./model_server/setup.py
cp ./model_server/setup.py /ie_serving_py

# ---- OVMS install ----
cd /ie_serving_py && python3 setup.py install
rm -rf ${OVMS_PATH}
