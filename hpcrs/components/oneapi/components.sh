#!/bin/bash

set -e

# Common components
dnf install -y \
	intel-basekit-getting-started \
	intel-oneapi-dev-utilities \
	intel-oneapi-common-licensing \
	intel-oneapi-common-vars
# DPCPP
dnf install -y \
	intel-oneapi-dpcpp-cpp-compiler \
	intel-oneapi-dpcpp-debugger \
	intel-oneapi-libdpstd-devel
# Install ifort (Intel Fortran)
dnf install -y \
    intel-oneapi-compiler-fortran
# Install icc (intel c++ compiler classic)
dnf install -y \
    intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic
# mkl and mpi libs
dnf install -y \
    intel-oneapi-mkl-devel intel-oneapi-mkl
# oneCCL
dnf install -y \
    intel-oneapi-ccl \
    intel-oneapi-ccl-devel
# oneTBB
dnf install -y intel-oneapi-tbb-devel
