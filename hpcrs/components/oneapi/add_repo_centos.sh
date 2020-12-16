#!/bin/bash

set -e


# install GPGPU drivers 
# https://dgpu-docs.intel.com/installation-guides/redhat/redhat-8.2.html
#dnf install -y intel-opencl intel-media intel-mediasdk level-zero intel-level-zero-gpu
tee > /etc/yum.repos.d/intel-graphics.repo << EOF
[intel-graphics]
name=Intel Graphics Drivers Repository
baseurl=https://repositories.intel.com/graphics/rhel/8.2
enabled=1
gpgcheck=0
repo_gpgcheck=0
EOF

# Add intel YUM (DNF) repository and install intel basekit
# https://software.intel.com/content/www/us/en/develop/articles/installing-intel-oneapi-toolkits-via-yum.html#instruct
tee > /etc/yum.repos.d/oneAPI.repo << EOF
[oneAPI]
name=Intel(R) oneAPI repository
baseurl=https://yum.repos.intel.com/oneapi
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://yum.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2023.PUB
EOF
