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
ARG ubuntu_ver=18.04

#--------------------------------------------------------------------
# TF Serving base build
#--------------------------------------------------------------------
FROM ubuntu:$ubuntu_ver as tfserving_build

ARG TF_SERVING_VERSION_GIT_BRANCH=r2.3
ARG TF_SERVING_VERSION_GIT_COMMIT=head

RUN apt-get update && apt-get install -y --no-install-recommends automake build-essential \
    ca-certificates curl git libcurl3-dev libfreetype6-dev libpng-dev libtool libzmq3-dev \
    mlocate openjdk-8-jdk openjdk-8-jre-headless pkg-config \
    software-properties-common swig unzip wget zip zlib1g-dev python3-distutils \
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
ARG TF_SERVING_BUILD_OPTIONS="--config=release"
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
# Openvino
#--------------------------------------------------------------------
FROM ubuntu:$ubuntu_ver as openvino_build
LABEL maintainer=otc-swstacks@intel.com
 
# Install SW packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y upgrade \
  && apt-get install -y --no-install-recommends apt-utils \
  curl ca-certificates gnupg2 wget python3-pip \
  libtool libdrm2 udev libgtk-3-0 python3-dev  \
  && rm -rf /var/lib/apt/lists/* \
  && ln -s /usr/bin/python3 /usr/bin/python \
  && ln -s /usr/bin/pip3 /usr/bin/pip

# install opencl
RUN apt-get update \
   && apt-get install -y --no-install-recommends ocl-icd-libopencl1 \
   && rm -rf /var/lib/apt/lists/* 

WORKDIR /workspace/

# install gpu drivers 
ENV VERSION="19.41.14441"
RUN  cd /workspace \
  && mkdir neo && cd neo \
  && wget https://github.com/intel/compute-runtime/releases/download/$VERSION/intel-gmmlib_19.3.2_amd64.deb \
  && wget https://github.com/intel/compute-runtime/releases/download/$VERSION/intel-igc-core_1.0.2597_amd64.deb \
  && wget https://github.com/intel/compute-runtime/releases/download/$VERSION/intel-igc-opencl_1.0.2597_amd64.deb \
  && wget https://github.com/intel/compute-runtime/releases/download/$VERSION/intel-opencl_19.41.14441_amd64.deb \
  && wget https://github.com/intel/compute-runtime/releases/download/19.41.14441/intel-ocloc_19.41.14441_amd64.deb \
  && dpkg -i *.deb && ldconfig && rm -r /workspace/neo

RUN wget https://apt.repos.intel.com/openvino/2020/GPG-PUB-KEY-INTEL-OPENVINO-2020 \
  && apt-key add GPG-PUB-KEY-INTEL-OPENVINO-2020 \
  && echo "deb https://apt.repos.intel.com/openvino/2020 all main" > /etc/apt/sources.list.d/intel-openvino-2020.list \
  && rm /workspace/GPG-PUB-KEY*

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  intel-openvino-eula-2020.4.287 intel-openvino-ie-rt-2020.4.287 \
  intel-openvino-ie-rt-core-ubuntu-bionic-2020.4.287 \
  intel-openvino-ie-rt-cpu-ubuntu-bionic-2020.4.287 \
  intel-openvino-ie-rt-gna-ubuntu-bionic-2020.4.287 \
  intel-openvino-ie-rt-gpu-ubuntu-bionic-2020.4.287 \
  intel-openvino-opencv-generic-2020.4.287 \
  intel-openvino-ie-bin-python-tools-ubuntu-bionic-2020.4.287 \
  intel-openvino-pot-2020.4.287 \
  intel-openvino-dev-ubuntu18-2020.4.287 \
  intel-openvino-dl-workbench-2020.4.287 \
  intel-openvino-ie-samples-2020.4.287 \
  intel-openvino-ie-sdk-ubuntu-bionic-2020.4.287 \
  intel-openvino-model-optimizer-2020.4.287 \
  intel-openvino-opencv-etc-2020.4.287 \
  intel-openvino-opencv-lib-ubuntu-bionic-2020.4.287 \
  intel-openvino-setupvars-2020.4.287 \
  && apt-get -y remove intel-openvino-ie-rt-hddl-ubuntu-bionic-2020.4.287 \
  && apt autoremove -y && rm -rf /var/lib/apt/lists/*

# install python user packages
RUN pip --no-cache-dir install "opencv-python==3.4.4.19" "numpy==1.13.3"

RUN echo "source /opt/intel/openvino/bin/setupvars.sh" >> /root/.bashrc \
  && /bin/bash -c "source /root/.bashrc"

RUN apt-get update \
  && apt-get install --no-install-recommends --yes cmake cpio build-essential \
  autoconf automake lsb-release libglib2.0-0 libgflags-dev \
  && /opt/intel/openvino/inference_engine/samples/c/build_samples.sh \
  && /opt/intel/openvino/inference_engine/samples/cpp/build_samples.sh \
  && apt-get remove -y python3-dev automake autoconf build-essential cmake lsb-release libgflags-dev \
  && apt autoremove -y \
  && apt-get update && apt-get install --no-install-recommends --yes libgflags2.2 \
  && rm -rf /var/lib/apt/lists/*

# Install TensorFlow Serving API from builder image
COPY --from=binary_build /usr/local/bin/tensorflow_model_server /usr/local/bin/tensorflow_model_server
COPY --from=binary_build /tmp/pip/ /tmp/pip/
RUN apt-get update && apt-get install -y --no-install-recommends \
    automake build-essential openjdk-8-jdk openjdk-8-jre-headless \
    && curl -fSsL -O https://bootstrap.pypa.io/get-pip.py \
    && python3 get-pip.py \
    && rm get-pip.py \
    && pip install setuptools \
    && pip --no-cache-dir install --upgrade /tmp/pip/tensorflow_serving_api-*.whl \
    && rm -rf /tmp/pip \
    && apt-get remove -y gcc automake build-essential openjdk-8-jdk openjdk-8-jre-headless \
    && apt-get install -y --no-install-recommends --no-install-suggests libpython3.6 \
    && apt-get clean \
     && apt-get autoclean -y && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# cleanup
COPY ./scripts/cleanup.sh ./cleanup.sh
RUN chmod +x ./cleanup.sh && ./cleanup.sh && rm ./cleanup.sh

COPY ./licenses/ /workspace/licenses
CMD ["/bin/bash"]
