#!/bin/bash
# Script for building spark with openblas support
set -xe

OPENBLAS_VERSION=$1

# Environment variables
INITIAL_DIR=$(pwd)
OPENBLAS_SRC_DIR="OpenBLAS-$OPENBLAS_VERSION"
OPENBLAS_BUILD_DIR="/tmp/openblas-build"
OPENBLAS_URL="https://github.com/xianyi/OpenBLAS/archive/v$OPENBLAS_VERSION.tar.gz"
AR=gcc-ar
RANLIB=gcc-ranlib
CFLAGS="$CFLAGS  -fno-semantic-interposition -O3 "
FFLAGS="$CFLAGS -fno-semantic-interposition -O3 -fno-f2c "
CXXFLAGS="$CXXFLAGS -fno-semantic-interposition -O3 "

if [ -d $OPENBLAS_BUILD_DIR ]
then
        rm -rf $OPENBLAS_BUILD_DIR/*
else
        mkdir $OPENBLAS_BUILD_DIR
fi

# Building OpenBLAS
cd $OPENBLAS_BUILD_DIR
curl -LO $OPENBLAS_URL
tar -xvf "v$OPENBLAS_VERSION.tar.gz"
cd $OPENBLAS_SRC_DIR
sed -i -e "s/\-O2/\-O3/g" Makefile*
export CFLAGS="$CFLAGS -march=haswell" 
export FFLAGS="$FFLAGS -march=haswell" 
grep -q '^flags .*avx2' /proc/cpuinfo 2>/dev/null || SKIPTESTS=CROSS=1 
cp lapack-netlib/make.inc.example lapack-netlib/make.inc
make TARGET=HASWELL F_COMPILER=GFORTRAN  SHARED=1 DYNAMIC_THREADS=1 USE_OPENMP=1 NO_AFFINITY=1  NUM_THREADS=128 NO_LAPACK=0
make install 

cd $INITIAL_DIR
