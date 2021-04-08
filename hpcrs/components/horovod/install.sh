#!/bin/bash

unset CCL_ROOT
unset CCL_CONFIGURATION
unset CCL_ATL_TRANSPORT
pip install --no-cache-dir psutil wheel
dnf install -y cmake python3-devel
HOROVOD_WITH_PYTORCH=1 HOROVOD_WITHOUT_MXNET=1 HOROVOD_WITHOUT_MPI=1 HOROVOD_WITHOUT_TENSORFLOW=1 pip --no-cache-dir install horovod
