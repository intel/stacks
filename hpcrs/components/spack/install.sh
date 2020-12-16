#!/bin/bash
# Spack recipe builder for HPCRS

set -e

# deps
dnf install -y wget bzip2

SPACK_VER=0.15.4

# install spack
cd /opt/ \
     && wget https://github.com/spack/spack/releases/download/v$SPACK_VER/spack-$SPACK_VER.tar.gz \
     && tar -xvf spack-$SPACK_VER.tar.gz \
     && mv spack-$SPACK_VER spack \
     && rm spack-$SPACK_VER.tar.gz

