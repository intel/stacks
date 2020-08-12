#---------------------------------------------------------------------------
# Builder stage on ClearLinux OS
#---------------------------------------------------------------------------
FROM clearlinux/stacks-clearlinux:33060 as base

RUN swupd update -y \
    && swupd bundle-add -y \
    wget curl cpio which \
    devpkg-llvm git python3-basic \
    && swupd clean --all

# Set up environment
WORKDIR /workspace
COPY ./components/*.sh components/

# Install IMPI
COPY ./components/impi/ components/impi/
RUN /workspace/components/impi/get_ext_impi.sh
RUN /workspace/components/impi/install_impi.sh
RUN find /opt/intel/impi/ -type f -name "*.a" -delete

# Install MKL
COPY ./components/mkl/ components/mkl/
RUN /workspace/components/mkl/get_ext_mkl.sh
RUN /workspace/components/mkl/install_mkl.sh
RUN find /opt/intel/mkl/ -type f -name "*.a" -delete

# Install IPS
COPY ./components/ips/ components/ips/
RUN /workspace/components/ips/get_ext_ips.sh
RUN /workspace/components/ips/install_ips.sh

# Build Pytorch Wheels
COPY ./components/pytorch/ components/pytorch/
RUN /workspace/components/pytorch/get_torch.sh
RUN /workspace/components/pytorch/build_torch_wheels.sh

# Cleanup
RUN rm -rf /opt/intel/conda_channel \
    && rm -rf /opt/intel/.scripts/*.rpm \
    && rm -rf /opt/intel/mkl/lib/ia32* \
    && rm -rf /opt/intel/tbb \
    && rm -rf /opt/intel/ide_support* \
    && rm -rf /opt/intel/licenses/* \
    && rm /opt/intel/.pset/component_upgrade/compxe_2020 \
    && rm -rf intel_sdp_products.db \
    && rm -rf /opt/intel/.pset/db/ \
    && rm -rf /opt/intel/samples_2020 \
    && rm -rf /opt/intel/intel_sdp_products.db \
    && find /opt/intel/ -name "*.log" | xargs rm -rf \
    && find /opt/intel/ -type d -name "benchmark*" | xargs rm -rf


#---------------------------------------------------------------------------
# Deployment image
#---------------------------------------------------------------------------
FROM clearlinux/stacks-clearlinux:33060 as final

LABEL authors="otc-swstacks@intel.com"
LABEL repo="https://github.com/intel/stacks"

# Install runtime dependencies, utils
RUN swupd bundle-add  \
    python3-basic openssh-server sysadmin-basic \
    which cpio c-basic wget \
    && swupd clean --all \
    && rm -rf /var/lib/swupd/*

# Copy compilers from base
COPY --from=base /opt/intel /opt/intel

# Set up environment
WORKDIR /workspace
COPY ./components/ components/

#Update license
COPY ./licenses/third-party-programs.txt   /workspace/
COPY ./licenses/clear_pkg_license.txt /usr/share/package-licenses/

# Install Pytorch and Torchvision
COPY --from=base /torch-wheels /torch-wheels
RUN pip --no-cache-dir install --prefix=/usr/local wheel \
    && pip install --no-cache-dir --prefix=/usr/local \
    psutil ipython mkl numpy pillow \
    && ldconfig \
    && /workspace/components/pytorch/install_torch.sh \
    && /workspace/components/pytorch/install_torchvision.sh \
    && /bin/bash -c "source /opt/intel/impi/2019.7.217/intel64/bin/mpivars.sh" \
    && HOROVOD_WITH_PYTORCH=1 pip --no-cache-dir install --prefix=/usr/local horovod[pytorch] \ 
    && ldconfig \
    && sed -i "s/__version__.*/__version__ = '1.4.0'/g" /usr/lib/python3.8/site-packages/torch/version.py \
    && find /usr/lib/ -follow -type f -name '*.pyc' -delete \
    && find /usr/lib/ -follow -type f -name '*.js.map' -delete \
    && rm /usr/local/lib/python3.8/site-packages/horovod/torch/*avx* \
    && pip uninstall -y mkl intel-openmp

# set env vars
RUN mkdir -p /etc/profile.d \
      && mv components/config_vars.sh /etc/profile.d \ 
      && mv components/sources.sh /etc/profile.d \
      && mkdir -p /tmp/intel_shm/4k/ /tmp/intel_shm/2m /tmp/intel_shm/1g \
      && echo "export I_MPI_SHM_FILE_PREFIX_4K=/tmp/intel_shm/4k" >> /etc/profile.d/sources.sh \
      && echo "export I_MPI_SHM_FILE_PREFIX_2M=/tmp/intel_shm/2m" >> /etc/profile.d/sources.sh \
      && echo "export I_MPI_SHM_FILE_PREFIX_1G=/tmp/intel_shm/1g" >> /etc/profile.d/sources.sh \
      && echo "export I_MPI_SHM=skx_avx512" >> /etc/profile.d/sources.sh \
      && echo "export I_MPI_FABRICS=shm:ofi" >> /etc/profile.d/sources.sh \
      && mkdir -p /etc/security \
      && touch /etc/security/limits.conf \
      && echo "root hard memlock unlimited" >> /etc/security/limits.conf \
      && echo "root soft memlock unlimited" >> /etc/security/limits.conf \
      && rm -rf /workspace/components

SHELL ["/bin/bash",  "-c"]
