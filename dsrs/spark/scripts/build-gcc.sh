#!/bin/bash
# Script for building spark with openblas support
set -xe

GCC_VERSION=$1

# Environment variables
INITIAL_DIR=$(pwd)
GCC_SRC_DIR="gcc-6.5.0"
GCC_BUILD_DIR="/tmp/gcc-build"
GCC_URL="http://mirrors.concertpass.com/gcc/releases/gcc-6.5.0/gcc-6.5.0.tar.gz"

if [ -d $GCC_BUILD_DIR ]
then
        rm -rf $GCC_BUILD_DIR/*
else
        mkdir $GCC_BUILD_DIR
fi

# Building GCC
cd $GCC_BUILD_DIR
curl -LO $GCC_URL
tar -xvf "gcc-6.5.0.tar.gz"
cd $GCC_SRC_DIR
contrib/download_prerequisites
mkdir build-dir
cd build-dir
../configure --prefix=/opt/gcc-build --disable-multilib --disable-multiarch --disable-bootstrap  --enable-languages=c,fortran
make -j 16
make install
cd $INITIAL_DIR

