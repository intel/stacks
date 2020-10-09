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

swupd bundle-add devpkg-libjpeg-turbo
swupd clean && rm -rf /var/lib/swupd/*

addons=( pytorch-lightning flair )
echo "=================installing pkg dependencies=================="
pip install --no-cache-dir -U \
  numpy pillow \
  scikit-image \
  twine \
  "pandas" \
  "test-tube" \
  "fastprogress" \
  beautifulsoup4 \
  numexpr \
  packaging \
  requests \
  "python-dateutil>=2.6.1" \
  "gensim>=3.4.0" \
  "pytest>=5.3.2" \
  "tqdm>=4.26.0" \
  "segtok>=1.5.7" \
  "matplotlib>=2.2.3" \
  mpld3==0.3 \
  "scikit-learn>=0.21.3" \
  "sqlitedict>=1.6.0" \
  "deprecated>=1.2.4" \
  "hyperopt>=0.1.1" \
  "transformers>=2.3.0" \
  "bpemb>=0.2.9" \
  regex \
  tabulate \
  langdetect \
  scipy

pip install --no-cache-dir --ignore-installed pyyaml==5.3.1
CC="cc -mavx2" pip install --no-cache-dir --force-reinstall "pillow-simd==7.0.0.post3"

for pkg in "${addons[@]}"
do
  echo "=================get and install $pkg======================="
  pip install --no-deps --no-cache-dir "$pkg" || { echo "failed installing $pkg"; exit 1; }
  echo "==================done======================================"
done
exit 0
