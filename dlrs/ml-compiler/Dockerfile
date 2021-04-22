#---------------------------------------------------------------------
# TVM ML Compiler on Ubuntu 20.04 Linux
#---------------------------------------------------------------------
ARG ubuntu_ver=20.04
FROM ubuntu:$ubuntu_ver as tvm_build
LABEL maintainer=otc-swstacks@intel.com

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    git python3-pip wget

RUN ln -s /usr/bin/python3.8 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip

# setup onednn and tvm
COPY ./scripts/ /scripts
RUN ./scripts/install_onednn.sh
RUN apt-get install -y llvm-dev cmake \
    build-essential wget git gcc python3-dev \
    && ./scripts/install_tvm.sh \
    && apt-get remove -y llvm-dev cmake wget gcc python3-dev \
    build-essential wget && apt-get -y autoremove \
    && apt-get install --no-install-recommends -y llvm-runtime libgomp1 \
    && rm -r /scripts \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# init
RUN echo "alias python=python3" >> ~/.bashrc \
    && echo "alias pip=pip3" >> ~/.bashrc
COPY ./licenses /workspace/licenses
HEALTHCHECK --interval=5m --timeout=3s \
  CMD python -c "import sys" || exit 1
SHELL ["/bin/bash", "-c"]

