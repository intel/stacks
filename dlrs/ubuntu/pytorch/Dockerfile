#--------------------------------------------------------------------
# Builder stage for MKL version of Pytorch and Torchvision on ClearLinux OS
#--------------------------------------------------------------------
ARG ubuntu_ver
FROM ubuntu:$ubuntu_ver as builder
LABEL maintainer=otc-swstacks@intel.com

# Install SW packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install wget git gcc g++ libopenmpi-dev python3-pip

# Fix for /usr/bin/python not found issue
RUN ln -s /usr/bin/python3.8 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip

# Install Pytorch build requirements
RUN python -m pip install --upgrade pip \
    && pip install --no-cache-dir cmake numpy ninja pyyaml mkl mkl-include setuptools cffi typing wheel

# Pytorch build
ENV GCC_IGNORE_WERROR=1 \
    CFLAGS="$CFLAGS -O3 -mfma -mtune=skylake-avx512 -march=native" \
    CXXFLAGS="$CXXFLAGS -O3 -mfma -mtune=skylake-avx512 -march=native" \
    GIT_BRANCH=v1.4.0 USE_FBGEMM=0

RUN git clone --recurse-submodules -j15 https://github.com/pytorch/pytorch.git --branch $GIT_BRANCH \
    && cd pytorch && mkdir /torch-wheels \
    && rm -rf caffe2/opt/onnxifi_op.* \
# Workaround for https://github.com/pytorch/pytorch/issues/26555
    && sed -i 's#^  ${CMAKE_CURRENT_SOURCE_DIR}/tensor_iterator_test.cpp##g' aten/src/ATen/test/CMakeLists.txt \
    && python setup.py bdist_wheel -d /torch-wheels && python setup.py install

# Torchvision build
ENV GCC_IGNORE_WERROR=1 \
    CFLAGS="$CFLAGS -O3 -mfma -mtune=skylake-avx512" \
    CXXFLAGS="$CXXFLAGS -O3 -mfma -mtune=skylake-avx512" \
    GIT_HASH=v0.5.0
RUN git clone https://github.com/pytorch/vision.git \
    && cd vision && git checkout ${GIT_HASH} && python setup.py bdist_wheel -d /torch-wheels \
    && cd / && rm -rf /scripts/vision

#--------------------------------------------------------------------
# Pytorch CPU on Ubuntu
#--------------------------------------------------------------------
ARG ubuntu_ver
FROM ubuntu:$ubuntu_ver
LABEL maintainer=otc-swstacks@intel.com

# Install SW packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install cmake protobuf-compiler \
    gcc g++ libjpeg-dev python3-pip openmpi-bin \
    openssh-server git libsm6 libxext6 libxrender-dev

# Fix for /usr/bin/python not found issue                                                                                                                                      
RUN ln -s /usr/bin/python3.8 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip

# Copy and install torch wheels from builder stage
COPY --from=builder /torch-wheels /torch-wheels
RUN pip --no-cache-dir install torch-wheels/* \
    && rm -rf /torch-wheels

# Set workdir
WORKDIR /workspace

# Install python packages
RUN pip --no-cache-dir install \
    psutil \
    tornado==5.1.1 \
    seldon-core \
    mkl \
    mkl-include \
    cython \
    docutils==0.15 \
    networkx==2.2 \
    typing-extensions \
    onnx "opencv-python==4.2.0.32" \
    && pip --no-cache-dir install horovod==0.19.0 \
    && pip --no-cache-dir install pip==18.1 \
    && pip --no-cache-dir install jupyterhub==1.1.0 --upgrade pip

COPY scripts/ ./scripts

# Install utils & addons
RUN ldconfig \
    && cd scripts \
    && ./install_addons.sh \
    && cd /workspace

# Generate defaults
ENV BASH_ENV /etc/profile
RUN cp ./scripts/generate_defaults.py /workspace && rm -rf ./scripts \
    && python generate_defaults.py --generate \
    && cat mkl_env.sh >> /etc/bash.bashrc \
    && chmod -R a+w /workspace

COPY /licenses/ /workspace/licenses/

# Init
SHELL ["/bin/bash",  "-c"]
