#!/bin/bash

INSTALL_ROOT=/opt/intel
# source icc and ifort
source "/etc/profile.d/config_vars.sh"
# source $INSTALL_ROOT/bin/compilervars.sh $ARCH

# source oneapi components
source $INSTALL_ROOT/oneapi/setvars.sh

export DPCPP_ROOT=/opt/intel/oneapi/compiler/latest/linux/
export LD_LIBRARY_PATH=${DPCPP_ROOT}/lib:${DPCPP_ROOT}/compiler/lib/intel64_lin:${LD_LIBRARY_PATH}
export INTELOCLSDKROOT=${DPCPP_ROOT}
export PATH=${DPCPP_ROOT}/bin:$PATH
export LD_LIBRARY_PATH=/opt/intel/oneapi/compiler/latest/linux/lib:/opt/intel/oneapi/compiler/latest/linux/lib/x64:/opt/intel/oneapi/compiler/latest/linux/lib/emu:/opt/intel/oneapi/compiler/latest/linux/compiler/lib/intel64_lin:/opt/intel/oneapi/compiler/latest/linux/compiler/lib:/opt/intel/oneapi/debugger/latest/dep/lib:/opt/intel/oneapi/debugger/latest/libipt/intel64/lib:/opt/intel/oneapi/debugger/latest/gdb/intel64/lib:/opt/intel/oneapi/tbb/latest/env/../lib/intel64/gcc4.8:/opt/intel/oneapi/ccl/latest/lib/cpu_gpu_dpcpp:$LD_LIBRARY_PATH
export CPATH=/opt/intel/oneapi/compiler/latest/linux/include:/opt/intel/oneapi/dev-utilities/latest/include:/opt/intel/oneapi/tbb/latest/env/../include:/opt/intel/oneapi/ccl/latest/include/cpu_gpu_dpcpp:$CPATH

