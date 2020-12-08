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

#export GIT_HASH=0ef928  # 2019_R1.0.1
#export GIT_HASH=ba6e22b  # 2019_R2
#export GIT_HASH=1c794d9  # 2019_R3
#export GIT_HASH=fe3f978   # 2019_R3.1
#export GIT_HASH=b2140c0 # 2020.1
#export GIT_HASH=2fe9b15 # 2020.3
export GIT_HASH=f557dca # 2021.1

echo "================= get dldt ================================="
if [ ! -d /dldt/ ]; then
    git clone -j "$N_JOBS" https://github.com/openvinotoolkit/openvino.git /dldt && \
    cd /dldt && git checkout -b v2021.1 $GIT_HASH &&\
    git submodule update --init --recursive && cd ..
fi
echo "================= install pip dependencies =================="
pip install --upgrade pip
pip install numpy cython progress opencv-python
