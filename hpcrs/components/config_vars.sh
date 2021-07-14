#!/usr/bin/env bash

# configuraton file for hpcrs

# version info
HPRS_VERSION=0.2.0-beta
INSTALL_ROOT=/opt/intel

# env vars
export CFLAGS="$CFLAGS -O3 -mfma -march=skylake-avx512 -mtune=skylake-avx512"
export FCFLAGS="$CFLAGS -O3 -mfma -march=skylake-avx512 -mtune=skylake-avx512"
export CXXFLAGS="$CXXFLAGS -O3 -mfma -march=skylake-avx512 -mtune=skylake-avx512"
