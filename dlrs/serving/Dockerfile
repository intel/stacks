# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#--------------------------------------------------------------------
# ARGs for FROM statements
#--------------------------------------------------------------------
ARG ubuntu_ver=20.04

#--------------------------------------------------------------------
# TF Serving base build
#--------------------------------------------------------------------
FROM ubuntu:$ubuntu_ver as tfserving_build

ARG TF_SERVING_VERSION_GIT_BRANCH=r2.4
ARG TF_SERVING_VERSION_GIT_COMMIT=head

ENV no_proxy=.intel.com,intel.com
ENV http_proxy=http://proxy-chain.intel.com:911
ENV https_proxy=http://proxy-chain.intel.com:912

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends automake build-essential \
    ca-certificates curl git libcurl3-dev libfreetype6-dev libpng-dev libtool libzmq3-dev \
    mlocate openjdk-8-jdk openjdk-8-jre-headless pkg-config \
    software-properties-common swig unzip wget zip zlib1g-dev python3-distutils \
    libmkl-intel-thread \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fSsL -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

# Install python 3.6.
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y \
    python3.6 python3.6-dev python3-pip python3.6-venv && \
    rm -rf /var/lib/apt/lists/* && \
    python3.6 -m pip install pip --upgrade && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 0

# Make python3.6 the default python version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 0

RUN pip3 --no-cache-dir install \
    future>=0.17.1 \
    grpcio \
    h5py \
    keras_applications>=1.0.8 \
    keras_preprocessing>=1.1.0 \
    mock \
    numpy \
    requests \
    --ignore-installed setuptools \
    --ignore-installed six>=1.12.0

# Set up Bazel
ENV BAZEL_VERSION 3.0.0
WORKDIR /
RUN mkdir /bazel && \
    cd /bazel && \
    curl -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36" -fSsL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    curl -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36" -fSsL -o /bazel/LICENSE.txt https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE && \
    chmod +x bazel-*.sh && \
    ./bazel-$BAZEL_VERSION-installer-linux-x86_64.sh && \
    cd / && \
    rm -f /bazel/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh

# Download TF Serving sources (optionally at specific commit).
WORKDIR /tensorflow-serving
RUN git clone --branch=${TF_SERVING_VERSION_GIT_BRANCH} https://github.com/tensorflow/serving . && \
    git remote add upstream https://github.com/tensorflow/serving.git && \
    if [ "${TF_SERVING_VERSION_GIT_COMMIT}" != "head" ]; then git checkout ${TF_SERVING_VERSION_GIT_COMMIT} ; fi

#--------------------------------------------------------------------
# Binary build
#--------------------------------------------------------------------
FROM tfserving_build as binary_build
# Build, and install TensorFlow Serving
ARG TF_SERVING_BUILD_OPTIONS="--config=release --config=mkl"
RUN echo "Building with build options: ${TF_SERVING_BUILD_OPTIONS}"
ARG TF_SERVING_BAZEL_OPTIONS=""
RUN echo "Building with Bazel options: ${TF_SERVING_BAZEL_OPTIONS}"

RUN bazel build --color=yes --curses=yes \
    ${TF_SERVING_BAZEL_OPTIONS} \
    --verbose_failures \
    --output_filter=DONT_MATCH_ANYTHING \
    --copt=-march="skylake-avx512" \
    ${TF_SERVING_BUILD_OPTIONS} \
    tensorflow_serving/model_servers:tensorflow_model_server && \
    cp bazel-bin/tensorflow_serving/model_servers/tensorflow_model_server \
    /usr/local/bin/

# Build and install TensorFlow Serving API
RUN bazel build --color=yes --curses=yes \
    ${TF_SERVING_BAZEL_OPTIONS} \
    --verbose_failures \
    --output_filter=DONT_MATCH_ANYTHING \
    --copt=-march="skylake-avx512" \
    ${TF_SERVING_BUILD_OPTIONS} \
    tensorflow_serving/tools/pip_package:build_pip_package && \
    bazel-bin/tensorflow_serving/tools/pip_package/build_pip_package \
    /tmp/pip
    
#--------------------------------------------------------------------
# Openvino and TF Serving Install
#--------------------------------------------------------------------
FROM ubuntu:$ubuntu_ver as serving_build
LABEL maintainer=otc-swstacks@intel.com

# Install SW packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade \
  && apt-get install -y --no-install-recommends apt-utils \
  curl ca-certificates gpg-agent pkg-config gnupg2 wget python3-pip \
  libtool libdrm2 udev libgtk-3-0 python3-dev software-properties-common \
  && rm -rf /var/lib/apt/lists/* \
  && ln -s /usr/bin/python3 /usr/bin/python \
  && ln -s /usr/bin/pip3 /usr/bin/pip

# install opencl
RUN apt-get update \
   && apt-get install -y --no-install-recommends ocl-icd-libopencl1 \
   && rm -rf /var/lib/apt/lists/* 

WORKDIR /workspace/

RUN export no_proxy=*.intel.com && update-ca-certificates --fresh \
  && curl -k https://apt.repos.intel.com/openvino/2021/GPG-PUB-KEY-INTEL-OPENVINO-2021 \
  | apt-key add - \
  && echo "deb https://apt.repos.intel.com/openvino/2021 all main" | tee /etc/apt/sources.list.d/intel-openvino-2021.list \
  && add-apt-repository -y "deb https://apt.repos.intel.com/openvino/2021 all main"

RUN export no_proxy=*.intel.com && apt-get update \
  && apt-get install -y --no-install-recommends \
  intel-openvino-eula-2021.1.110 intel-openvino-ie-rt-2021.2.200 \
  intel-openvino-ie-rt-core-ubuntu-focal-2021.2.200 \
  intel-openvino-ie-rt-cpu-ubuntu-focal-2021.2.200 \
  intel-openvino-ie-rt-gna-ubuntu-focal-2021.2.200 \
  intel-openvino-ie-rt-gpu-ubuntu-focal-2021.2.200 \
  intel-openvino-opencv-lib-ubuntu-focal-2021.2.200 \
  intel-openvino-ie-bin-python-tools-ubuntu-focal-2021.2.200 \
  intel-openvino-ie-sdk-ubuntu-focal-2021.2.200 \
  intel-openvino-opencv-generic-2021.2.200 \
  intel-openvino-pot-2021.2.200 \
  intel-openvino-dev-ubuntu20-2021.2.200 \
  intel-openvino-dl-workbench-2021.2.200 \
  intel-openvino-ie-samples-2021.2.200 \
  intel-openvino-model-optimizer-2021.2.200 \
  intel-openvino-opencv-etc-2021.2.200 \
  intel-openvino-setupvars-2021.2.200 \
  && apt-get -y remove intel-openvino-ie-rt-hddl-ubuntu-focal-2021.2.200 \
  && apt autoremove -y && rm -rf /var/lib/apt/lists/*

# install gpu drivers 
ENV VERSION="20.41.18123"
RUN  cd /workspace \
  && mkdir neo && cd neo \
  && wget https://github.com/intel/compute-runtime/releases/download/$VERSION/intel-gmmlib_20.3.1_amd64.deb \
  && wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.5186/intel-igc-core_1.0.5186_amd64.deb \
  && wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.5186/intel-igc-opencl_1.0.5186_amd64.deb \
  && wget https://github.com/intel/compute-runtime/releases/download/$VERSION/intel-opencl_20.41.18123_amd64.deb \
  && wget https://github.com/intel/compute-runtime/releases/download/$VERSION/intel-ocloc_20.41.18123_amd64.deb \
  && dpkg -i *.deb && ldconfig && rm -r /workspace/neo

# install python user packages
RUN pip --no-cache-dir install "opencv-python==3.4.*" "numpy==1.19.*"

RUN echo "source /opt/intel/openvino_2021.2.200/bin/setupvars.sh" >> /root/.bashrc \
  && /bin/bash -c "source /root/.bashrc"

RUN apt-get update \
  && apt-get install --no-install-recommends --yes cmake cpio build-essential \
  autoconf automake lsb-release libglib2.0-0 libgflags-dev \
  && /opt/intel/openvino_2021/inference_engine/samples/c/build_samples.sh \
  && /opt/intel/openvino_2021/inference_engine/samples/cpp/build_samples.sh \
  && apt-get remove -y python3-dev automake autoconf build-essential cmake lsb-release libgflags-dev \
  && apt autoremove -y \
  && apt-get update && apt-get install --no-install-recommends --yes libgflags2.2 \
  && rm -rf /var/lib/apt/lists/*

# Install TensorFlow Serving API from builder image
COPY --from=binary_build /usr/local/bin/tensorflow_model_server /usr/local/bin/tensorflow_model_server
COPY --from=binary_build /tmp/pip/ /tmp/pip/
COPY --from=binary_build /root/.cache/bazel/_bazel_root/*/external/mkl_linux/lib/* /usr/lib
COPY --from=binary_build /root/.cache/bazel/_bazel_root/*/execroot/tf_serving/bazel-out/k8-opt/bin/external/llvm_openmp/libiomp5.so /usr/lib
RUN apt-get update && apt-get install -y --no-install-recommends \
    automake build-essential openjdk-8-jdk openjdk-8-jre-headless \
    && curl -fSsL -O https://bootstrap.pypa.io/get-pip.py \
    && python3 get-pip.py \
    && rm get-pip.py \
    && pip install setuptools \
    && pip --no-cache-dir install --upgrade /tmp/pip/tensorflow_serving_api-*.whl \
    && rm -rf /tmp/pip \
    && apt-get remove -y gcc automake build-essential openjdk-8-jdk openjdk-8-jre-headless \
    && apt-get install -y --no-install-recommends --no-install-suggests libpython3.8 libpython3.8-dev \
    && apt-get clean \
     && apt-get autoclean -y && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# cleanup
COPY ./scripts/cleanup.sh ./cleanup.sh
RUN chmod +x ./cleanup.sh && ./cleanup.sh && rm ./cleanup.sh

COPY ./licenses/ /workspace/licenses
#--------------------------------------------------------------------
# Final Serving image
#--------------------------------------------------------------------
FROM ubuntu:$ubuntu_ver as serving
LABEL maintainer=otc-swstacks@intel.com

COPY --from=serving_build / /
HEALTHCHECK --interval=5m --timeout=3s \
  CMD python -c "import sys" || exit 1
SHELL ["/bin/bash",  "-c"]
