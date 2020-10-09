#---------------------------------------------------------------------------
# Builder stage for MKL version of Pytorch and Torchvision on ClearLinux OS
#---------------------------------------------------------------------------
ARG clear_ver
FROM clearlinux/stacks-clearlinux:$clear_ver as builder

# Install SW packages
RUN swupd bundle-add wget \
    openssh-server devpkg-openmpi devpkg-llvm git which python3-basic \
    && swupd clean && rm -rf /var/lib/swupd/*

# Install Pytorch build requirements
WORKDIR buildir
COPY scripts/torch_utils.sh .
RUN ./torch_utils.sh

# Pytorch build
ENV GCC_IGNORE_WERROR=1 \
    CFLAGS="$CFLAGS -O3 -mfma -march=skylake-avx512 -mtune=cascadelake" \
    CXXFLAGS="$CXXFLAGS -O3 -mfma -march=skylake-avx512 -mtune=cascadelake" \
    USE_FBGEMM=0

RUN cd /buildir/pytorch \
    && python setup.py bdist_wheel -d /torch-wheels && python setup.py install

# Torchvision build
ENV GCC_IGNORE_WERROR=1 \
    CFLAGS="$CFLAGS -O3 -mfma -mtune=skylake-avx512" \
    CXXFLAGS="$CXXFLAGS -O3 -mfma -mtune=skylake-avx512"

RUN cd /buildir/vision && python setup.py bdist_wheel -d /torch-wheels

#--------------------------------------------------------------------
# Pytorch CPU on ClearLinux
#--------------------------------------------------------------------
ARG clear_ver
FROM clearlinux/stacks-clearlinux:$clear_ver
LABEL maintainer=otc-swstacks@intel.com

# Set workspace
WORKDIR /workspace
COPY scripts/ ./scripts

# Install SW packages
COPY --from=builder /torch-wheels torch-wheels/
RUN swupd bundle-add  \
    python3-basic openssh-server openmpi git sysadmin-basic \
    devpkg-openmpi devpkg-gperftools devpkg-opencv \
    && rm -rf /var/lib/swupd/* \
    && ln -s /usr/lib64/libtcmalloc.so /usr/lib/libtcmalloc.so

# Install torch wheels from builder stage
RUN ldconfig \
    && pip --no-cache-dir install torch-wheels/* \
    && rm -rf torch-wheels/

# Install runtime dependencies, utils and add-ons
RUN pip --no-cache-dir install \
    psutil jupyterhub==1.1.0 \
    seldon-core==1.0.2 \
    mkl mkl-include
RUN ldconfig && pip --no-cache-dir install \
    typing-extensions horovod==0.19.0 \
    && ./scripts/install_addons.sh

# Generate defaults
ENV BASH_ENV /usr/share/defaults/etc/profile
RUN cp ./scripts/generate_defaults.py /workspace && rm -rf ./scripts \
    && python generate_defaults.py --generate \
    && cat mkl_env.sh >> /etc/profile \
    && chmod -R a+w /workspace

# Init
SHELL ["/bin/bash",  "-c"]
