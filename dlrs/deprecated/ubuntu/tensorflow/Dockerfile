#--------------------------------------------------------------------
# Builder stage for MKL version of Tensorflow on Ubuntu
#--------------------------------------------------------------------
ARG ubuntu_ver
FROM ubuntu:$ubuntu_ver as tf_builder
LABEL maintainer=otc-swstacks@intel.com

# Install SW packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install git wget python3-pip pkg-config zip g++ zlib1g-dev unzip build-essential golang-go


# Fix for /usr/bin/python not found issue
RUN ln -s /usr/bin/python3.8 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip

RUN pip install enum34

RUN go get github.com/bazelbuild/bazelisk \
    && export PATH=$PATH:~/go/bin/ \
    && ln -s ~/go/bin/bazelisk /usr/bin/bazel

# Copy scripts and patches
COPY ./scripts/install_tensorflow.sh /scripts/install_tensorflow.sh
COPY ./patches /patches

# Build Tensorflow
RUN ./scripts/install_tensorflow.sh

#--------------------------------------------------------------
# Builder instance for OpenVINO on Ubuntu
#--------------------------------------------------------------
ARG ubuntu_ver
FROM ubuntu:$ubuntu_ver as serving_builder
LABEL maintainer=otc-swstacks@intel.com

# Install SW packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install cmake libopencv-dev python3-dev git python3-pip

# Fix for /usr/bin/python not found issue
RUN ln -s /usr/bin/python3.8 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip

# Copy scripts and patches
COPY ./scripts/build_openvino_ie.sh /scripts/build_openvino_ie.sh
COPY ./patches /patches

#Build OpenVINO
RUN ./scripts/build_openvino_ie.sh

#--------------------------------------------------------------
# DLRS downstream container
#--------------------------------------------------------------
ARG ubuntu_ver
FROM ubuntu:$ubuntu_ver as base
LABEL maintainer=otc-swstacks@intel.com

ARG NUMACTL_VERSION=2.0.12
ARG HOROVOD_VERSION=0.19.0
ARG MODEL_SERVER_TAG=v2020.1

# Install SW packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install gcc g++ openmpi-bin git openssh-server python3-pip curl libtbb2

# Symlink for missing libiomp5 library
RUN ln -s /usr/lib/llvm-10/lib/libomp.so.5 /usr/lib/libiomp5.so

# Fix for /usr/bin/python not found issue
RUN ln -s /usr/bin/python3.8 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip

RUN curl -fSsL -O https://github.com/numactl/numactl/releases/download/v${NUMACTL_VERSION}/numactl-${NUMACTL_VERSION}.tar.gz \
    && tar xf numactl-${NUMACTL_VERSION}.tar.gz \
    && cd numactl-${NUMACTL_VERSION} \
    && ./configure \
    && make \
    && make install \
    && rm -rf /numactl-${NUMACTL_VERSION}*

COPY --from=tf_builder /tmp/tf/ /tmp/tf/
COPY --from=serving_builder /dldt/bin/intel64/Release/lib/ /usr/local/lib/inference-engine/

# install tensorflow, ntlk, jupyterhub, opencv, seldon-core and horovod
RUN pip --no-cache-dir install /tmp/tf/avx512/tensorflow*.whl \
    && rm -rf /tmp/tf

RUN pip --no-cache-dir install horovod==${HOROVOD_VERSION} \
    && pip --no-cache-dir install common \
    notebook protobuf \
    numpy tensorflow-serving-api==1.15.0 \
    google-cloud-storage boto3 jsonschema falcon cheroot \
    seldon-core==1.0.1 numpy \
    grpcio defusedxml==0.5.0 grpcio-tools test-generator==0.1.1 \
    && pip --no-cache-dir install pip==18.1 \
    && pip --no-cache-dir install jupyterhub==1.1.0 --upgrade pip \
    && find /usr/lib/ -follow -type f -name '*.pyc' -delete \
    && find /usr/lib/ -follow -type f -name '*.js.map' -delete 

# install openvino inference engine
# init
ENV BASH_ENV /etc/profile
RUN sed -i '1s;^;export LD_LIBRARY_PATH=/usr/local/lib/inference-engine:/usr/local/lib\n;' /etc/bash.bashrc && \
    sed -i '1s;^;export PYTHONPATH=/usr/local/lib/inference-engine/python_api/python3.8:/usr/local/lib/inference-engine/python_api/python3.8/openvino/inference_engine/\n;' /etc/bash.bashrc

# init ie serving
WORKDIR /ie_serving_py
RUN git clone --depth 1 -b ${MODEL_SERVER_TAG} https://github.com/IntelAI/OpenVINO-model-server.git model_server \
    && cd model_server && git checkout ${MODEL_SERVER_TAG} && cd ..  \
    && cp ./model_server/setup.py /ie_serving_py \
    && echo "OpenVINO Model Server version: ${MODEL_SERVER_TAG}" > /ie_serving_py/version \
    && echo "Git commit: `cd ./model_server; git rev-parse HEAD; cd ..`" >> /ie_serving_py/version \
    && echo "OpenVINO version: ${MODEL_SERVER_TAG} src" >> /ie_serving_py/version \
    && echo "# OpenVINO built with: https://github.com/opencv/dldt.git" >> /ie_serving_py/version \
    && cp -r ./model_server/ie_serving /ie_serving_py/ie_serving \
    && cd /ie_serving_py && python3 setup.py install \
    && rm -rf model_server

WORKDIR /workspace
COPY /scripts/ /workspace/scripts/
RUN chmod -R a+w /workspace

COPY /licenses/ /workspace/licenses/

# Init
SHELL ["/bin/bash",  "-c"]
