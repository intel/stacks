#---------------------------------------------------------------------------
# Builder stage on Centos OS
#---------------------------------------------------------------------------
FROM centos:8 as base

RUN yum update -y \
    && yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && yum install -y jemalloc-devel wget curl git \
    python3-pip python3 python36-devel.x86_64 \
    && dnf -y install gcc-toolset-9-gcc gcc-toolset-9-gcc-c++ \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip

ENV PATH=/opt/rh/gcc-toolset-9/root/usr/bin:$PATH


# Set up environment
WORKDIR /workspace
COPY ./components/*.sh components/

# Add oneapi repo
COPY ./components/oneapi/ components/oneapi
RUN /workspace/components/oneapi/add_repo_centos.sh

# Add DPC++
RUN /workspace/components/oneapi/dpcpp.sh

# Install common - license and vars
RUN /workspace/components/oneapi/common.sh

# Install onetbb
RUN /workspace/components/oneapi/onetbb.sh

# Install oneccl
RUN /workspace/components/oneapi/oneccl.sh

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
COPY ./components/pytorch/ .
RUN pip --no-cache-dir install -r /workspace/requirements.txt wheel
RUN /workspace/torch_utils.sh
RUN cd /workspace/pytorch \
    && python setup.py bdist_wheel -d /torch-wheels

# install recipe builder
COPY ./components/spack components/spack
RUN ./components/spack/install.sh

# Cleanup
RUN rm -rf /opt/intel/conda_channel \
    && rm -rf /opt/intel/.scripts/*.rpm \
    && rm -rf /opt/intel/oneapi/conda_channel \
    && rm -rf /opt/intel/tbb \
    && rm -rf /opt/intel/ide_support* \
    && rm -rf /opt/intel/licenses/* \
    && rm /opt/intel/.pset/component_upgrade/compxe_2020 \
    && rm -rf intel_sdp_products.db \
    && rm -rf /opt/intel/.pset/db/ \
    && rm -rf /opt/intel/samples_2020 \
    && find /opt/intel/ -name "*.deb*" | xargs rm -rf \
    && find /opt/intel/ -name "*.rpm*" | xargs rm -rf \
    && find /opt/intel/ -name "*.tgz*" | xargs rm -rf \
    && find /opt/intel/ -name "*.tar.bz2*" | xargs rm -rf \
    && find /opt/intel/ -name "*.log" | xargs rm -rf \
    && find /opt/intel/ -type d -name "benchmark*" | xargs rm -rf


#---------------------------------------------------------------------------
# Deployment image
#---------------------------------------------------------------------------
FROM centos:8 as final

LABEL authors="otc-swstacks@intel.com"
LABEL repo="https://github.com/intel/stacks"

# Install runtime dependencies, utils
RUN yum update -y \
    && yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && yum install -y which cpio wget openssh-server \
    libjpeg-devel zlib-devel git make \
    jemalloc python3-pip python3 python3-devel libgomp \
    && dnf -y install gcc-toolset-9-gcc gcc-toolset-9-gcc-c++ \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip

ENV PATH=/opt/rh/gcc-toolset-9/root/usr/bin:$PATH

# Copy compilers from base
COPY --from=base /opt/intel /opt/intel

# Set up environment
WORKDIR /workspace

#Update third-party license file
COPY ./licenses/third-party-programs_v2.txt   /workspace/

# Install Pytorch and Torchvision
COPY --from=base /torch-wheels /torch-wheels
RUN pip --no-cache-dir install /torch-wheels/* \
    && rm -rf /torch-wheels

# Install torchvision
RUN pip --no-cache-dir install torchvision==0.8.1+cpu \
        -f https://download.pytorch.org/whl/torch_stable.html

# Install Horovod
COPY ./components/pytorch/requirements.txt .
RUN pip install --upgrade pip \
    && pip --no-cache-dir install --no-deps -r requirements.txt \
    && rm -rf ./requirements.txt \
    && /bin/bash -c "source /opt/intel/impi/2019.7.217/intel64/bin/mpivars.sh" \
    && HOROVOD_WITH_PYTORCH=1 pip install horovod==0.19.5\
    && pip uninstall -y mkl mkl-include intel-openmp \
    && find /usr/lib/ -follow -type f -name '*.pyc' -delete \
    && find /usr/lib/ -follow -type f -name '*.js.map' -delete 

# Install addons
RUN pip install --no-cache-dir --prefix=/usr/local \
    psutil ipython numpy pillow

# install omnipath userspace drivers
COPY ./components/omnipath/ components/omnipath
RUN components/omnipath/drivers.sh \
    && rm -rf components/omnipath

# install libfabrics with omnipath support
COPY ./components/libfabrics components/libfabrics
RUN components/libfabrics/install.sh \
    && rm -rf components/libfabrics

# install spack pkg manager
COPY --from=base /opt/spack /opt/spack
RUN dnf install -y gcc-c++ && dnf clean all

# add oneapi repos
COPY ./components/oneapi/add_repo_centos.sh components/oneapi/add_repo_centos.sh
RUN components/oneapi/add_repo_centos.sh \
    && rm -rf /components/oneapi

# Insall dgpu userlibs (oneccl req)
COPY ./components/oneapi/dgpu.sh /workspace/components/oneapi/dgpu.sh
RUN /workspace/components/oneapi/dgpu.sh \
    && rm -rf /workspace/components/oneapi

# set env vars
RUN mkdir -p /etc/profile.d
COPY ./components/config_vars.sh /etc/profile.d
COPY ./components/sources.sh /etc/profile.d
RUN mkdir -p /tmp/intel_shm/4k/ /tmp/intel_shm/2m /tmp/intel_shm/1g \
    && echo "export I_MPI_SHM_FILE_PREFIX_4K=/tmp/intel_shm/4k" >> /etc/profile.d/sources.sh \
    && echo "export I_MPI_SHM_FILE_PREFIX_2M=/tmp/intel_shm/2m" >> /etc/profile.d/sources.sh \
    && echo "export I_MPI_SHM_FILE_PREFIX_1G=/tmp/intel_shm/1g" >> /etc/profile.d/sources.sh \
    && echo "export I_MPI_SHM=skx_avx512" >> /etc/profile.d/sources.sh \
    && echo "export I_MPI_FABRICS=shm:ofi" >> /etc/profile.d/sources.sh \
    && echo "source /opt/spack/share/spack/setup-env.sh" >> /etc/profile.d/sources.sh \
    && mkdir -p /etc/security \
    && touch /etc/security/limits.conf \
    && echo "root hard memlock unlimited" >> /etc/security/limits.conf \
    && echo "root soft memlock unlimited" >> /etc/security/limits.conf \
    && rm -rf /workspace/components

SHELL ["/bin/bash",  "-c"]
