#!/usr/bin/env bash

# configuraton file for hpcrs

# version info
HPRS_VERSION=0.1.0-beta

# env vars
export CFLAGS="$CFLAGS -O3 -mfma -march=skylake-avx512 -mtune=skylake-avx512"
export FCFLAGS="$CFLAGS -O3 -mfma -march=skylake-avx512 -mtune=skylake-avx512"
export CXXFLAGS="$CXXFLAGS -O3 -mfma -march=skylake-avx512 -mtune=skylake-avx512"

# compilation flags
GCC_IGNORE_WERROR=1

# common uris
URL=http://registrationcenter-download.intel.com/akdlm/irc_nas/tec
LOGFILE="install.log"
INSTALL_ROOT=/opt/intel
TEMP_ROOT=/tmp/hpc

# MKL
MKL_DIR_NR=16533
MKL_V="l_mkl_2020.1.217"

# Intel MPI
IMPI_DIR_NR=16546
IMPI_V="l_mpi_2019.7.217"

# IPS - Intel Parallel Studio
IPS_DIR_NR=16530
IPS_V=parallel_studio_xe_2020_update1_composer_edition
ARCH=intel64 # Needed for sourcing compilers

# PyTorch
TORCH_VER=v1.4.0 # Pytorch branch
TORCHVISION_VER=v0.5.0 # Torchvision tag
HVD_VER=0.19.1
BUILD_ONNX_PYTHON=1
HOROVOD_WITH_PYTORCH=1
USE_FBGEMM=0
BUILD_TESTS=OFF