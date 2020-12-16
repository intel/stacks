#!/bin/bash

# source icc and ifort
source "/etc/profile.d/config_vars.sh"
source $INSTALL_ROOT/bin/compilervars.sh $ARCH

# source impi
source /opt/intel/compilers_and_libraries_2020.1.217/linux/mpi/intel64/bin/mpivars.sh

# source oneapi components
source $INSTALL_ROOT/oneapi/setvars.sh

export DPCPP_ROOT=/opt/intel/oneapi/compiler/latest/linux/
export LD_LIBRARY_PATH=${DPCPP_ROOT}/lib:${DPCPP_ROOT}/compiler/lib/intel64_lin:${LD_LIBRARY_PATH}
export INTELOCLSDKROOT=${DPCPP_ROOT}
export PATH=${DPCPP_ROOT}/bin:$PATH
export LD_LIBRARY_PATH=/opt/intel/oneapi/compiler/2021.1-beta10/linux/lib:/opt/intel/oneapi/compiler/2021.1-beta10/linux/lib/x64:/opt/intel/oneapi/compiler/2021.1-beta10/linux/lib/emu:/opt/intel/oneapi/compiler/2021.1-beta10/linux/compiler/lib/intel64_lin:/opt/intel/oneapi/compiler/2021.1-beta10/linux/compiler/lib:/opt/intel/oneapi/debugger/10.0-beta10/dep/lib:/opt/intel/oneapi/debugger/10.0-beta10/libipt/intel64/lib:/opt/intel/oneapi/debugger/10.0-beta10/gdb/intel64/lib:/opt/intel/oneapi/tbb/2021.1-beta10/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/ccl/2021.1-beta10/lib/cpu_gpu_dpcpp:$LD_LIBRARY_PATH
export CPATH=/opt/intel/oneapi/compiler/2021.1-beta10/linux/include:/opt/intel/oneapi/dev-utilities/2021.1-beta10/include:/opt/intel/oneapi/tbb/2021.1-beta10/env/../include:/opt/intel/oneapi/ccl/2021.1-beta10/include/cpu_gpu_dpcpp:$CPATH

