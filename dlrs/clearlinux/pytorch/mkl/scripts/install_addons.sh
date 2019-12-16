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

# pillow need libjpeg
swupd bundle-add devpkg-libjpeg-turbo
export PATH=/opt/conda/bin:$PATH
[[ -f  /opt/conda/compiler_compat/ld ]] && rm  /opt/conda/compiler_compat/ld

addons=( pytorch-lightning flair )
echo "=================installing pkg dependencies=================="
pip install --no-cache-dir \
  scikit-learn==0.20.2 \
  scikit-image \
  tqdm==4.35.0 \
  twine==1.13.0 \
  numpy==1.16.4 \
  "pandas>=0.20.3" \
  "test-tube>=0.6.9" \
	bottleneck \
	"fastprogress>=0.1.19"\
	beautifulsoup4 \
	matplotlib \
	numexpr \
	packaging \
	pyyaml \
	requests \
	flair \
	scipy
CC="cc -mavx2" pip install --no-cache-dir --force-reinstall pillow-simd
for pkg in "${addons[@]}"
do
  echo "=================get and install $pkg======================="
  pip install --no-deps --no-cache-dir "$pkg" || { echo "failed installing $pkg"; exit 1; }
  echo "==================done======================================"
done
exit 0
