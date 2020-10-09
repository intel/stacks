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

DNNL_VER=1.6
URL=https://github.com/oneapi-src/oneDNN/releases/download/v$DNNL_VER

wget $URL/dnnl_lnx_$DNNL_VER.0_cpu_gomp.tgz -O /tmp/dnnl.tgz \
    && cd /tmp/ && tar -xzf dnnl.tgz \
    && mv dnnl_lnx_* dnnl/

# copy libs and headers
mv /tmp/dnnl/lib/libdnnl* /usr/local/lib/ \
    && mv /tmp/dnnl/include/* /usr/local/include/ \
    && rm -rf /tmp/* \
    && ldconfig && cd /
