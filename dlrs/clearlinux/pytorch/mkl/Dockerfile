#--------------------------------------------------------------------
# Base image to build MKL version of Pytorch on ClearLinux OS
#--------------------------------------------------------------------
ARG clear_ver
FROM clearlinux/stacks-clearlinux:$clear_ver as base
LABEL maintainer=otc-swstacks@intel.com

# update os and add pkgs
RUN swupd bundle-add wget \
    openssh-server devpkg-openmpi devpkg-llvm git which \
    && rm -rf /var/lib/swupd/*
# copy and execute installation scripts
COPY ./scripts /scripts
RUN cd /scripts \
  && ./install_conda.sh \
  && ./install_torch_deps.sh \ 
  && ./install_pytorch.sh \
  && ./install_torchvision.sh \
  && ./install_utils.sh \
  && cd / && rm -rf /scripts \
  && rm -rf /opt/conda/pkgs/mkl*

# cv2 deps
RUN /opt/conda/bin/conda install -y -c conda-forge \
    xorg-libsm xorg-libxrender \
    xorg-libxext xorg-libxau \
    && /opt/conda/bin/conda clean -afy \
    && rm -f /opt/conda/bin/ffmpeg \
    && rm -f /opt/conda/bin/jasper \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.pyc' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete
#--------------------------------------------------------------------
# Pytorch CPU on ClearLinux
#--------------------------------------------------------------------
ARG clear_ver
FROM clearlinux/stacks-clearlinux:$clear_ver
LABEL maintainer=otc-swstacks@intel.com

# update os and add pkgs
RUN swupd bundle-add  \
    openssh-server openmpi git sysadmin-basic devpkg-gperftools \
    && rm -rf /var/lib/swupd/* \
    && ln -s /usr/lib64/libtcmalloc.so /usr/lib/libtcmalloc.so

COPY --from=base /opt/conda/ /opt/conda
#init
WORKDIR /workspace

RUN /opt/conda/bin/pip --no-cache-dir install \
    psutil \
    onnx \
    jupyterhub==1.0.0 \
    seldon-core

# install addons
COPY ./scripts/install_addons.sh .
RUN ./install_addons.sh && rm ./install_addons.sh
COPY ./scripts/generate_defaults.py /workspace
RUN echo "export PATH=/opt/conda/bin:$PATH" >> /.bashrc \
    && echo "export LD_LIBRARY_PATH=/usr/lib64:/opt/conda/lib" >> /.bashrc \
    && /opt/conda/bin/python generate_defaults.py --generate \
    && cat mkl_env.sh >> /.bashrc \
    && chmod -R a+w /workspace 
SHELL ["/bin/bash",  "-c",  "source /.bashrc"]
