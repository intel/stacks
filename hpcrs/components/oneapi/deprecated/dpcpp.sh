#!/bin/bash

set -e


dnf install -y \
	intel-oneapi-dpcpp-cpp-compiler \
	intel-oneapi-dpcpp-debugger \
	intel-oneapi-libdpstd-devel
