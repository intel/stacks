#---------------------------------------------------------------------------
# Builder stage on Centos OS
#---------------------------------------------------------------------------
FROM centos:8 as base

RUN yum update -y \
    && yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && yum install -y jemalloc-devel wget curl git \
    python3-pip python3 python36-devel.x86_64 \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip

ENV PATH=/opt/rh/gcc-toolset-9/root/usr/bin:$PATH


# Set up environment
WORKDIR /workspace
COPY ./components/*.sh components/

# Add oneapi repo
COPY ./components/oneapi/ components/oneapi
RUN /workspace/components/oneapi/add_repo_centos.sh

# Add oneapi components
RUN /workspace/components/oneapi/components.sh

# install recipe builder
COPY ./components/spack components/spack
RUN ./components/spack/install.sh

# Cleanup
RUN find /opt/intel/ -name "*.deb*" | xargs rm -rf \
    && find /opt/intel/ -name "*.rpm*" | xargs rm -rf \
    && rm -rf /opt/intel/oneapi/intelpython/ \
    && rm -rf /opt/intel/oneapi/conda_channel/ \
    && rm -rf /opt/intel/oneapi/dal/ \
    && rm -rf /opt/intel/oneapi/ipp/ \
    && rm -rf /opt/intel/oneapi/dev-utilities/ \
    && rm -rf /opt/intel/oneapi/mpi/latest/lib/debug* \
    && rm -rf /opt/intel/oneapi/mpi/latest/lib/release_mt \
    && rm -rf /opt/intel/oneapi/compiler/2021.1.2/linux/lib/oclfpga/ \
    && find /opt/intel/ -name "*.tgz*" | xargs rm -rf || true \
    && find /opt/intel/ -name "*.tar.bz2*" | xargs rm -rf || true \
    && find /opt/intel/ -name "*.log" | xargs rm -rf || true \
    && find /opt/intel/ -name "*.jar" | xargs rm -rf || true \
    && find /opt/intel/ -type d -name "benchmark*" | xargs rm -rf || true \
    && find /opt/intel/oneapi/mkl/ -name "*.a" | xargs rm -rf || true \
    && find /opt/intel/oneapi/mpi/latest/lib/release -name "*.a" | xargs rm -rf || true


#---------------------------------------------------------------------------
# Deployment image
#---------------------------------------------------------------------------
FROM centos:8 as final

LABEL authors="otc-swstacks@intel.com"
LABEL repo="https://github.com/intel/stacks"

COPY --from=base /opt/ /opt/

WORKDIR /workspace
# add core components
COPY ./components components/
RUN yum update -y \
    && yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
    && yum install -y which cpio wget openssh-server git make python3-pip python3 \
    && dnf install -y gcc-gfortran gcc gcc-c++ \
    && dnf upgrade -y \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip \
    && ./components/oneapi/add_repo_centos.sh \
    && ./components/pytorch/install.sh \
    && ./components/horovod/install.sh \
    && ./components/omnipath/drivers.sh \
    && mkdir -p /etc/profile.d \
    && cp components/config_vars.sh /etc/profile.d \
    && cp components/sources.sh /etc/profile.d \
    && mkdir -p /tmp/intel_shm/4k/ /tmp/intel_shm/2m /tmp/intel_shm/1g \
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
    && cp components/licenses/third-party-programs_v3.txt   /workspace/ \
    && rm -rf /workspace/components \
    && find /opt/intel/ -name "*.deb*" | xargs rm -rf || true \
    && find /opt/intel/ -name "*.rpm*" | xargs rm -rf || true\
    && find /usr/lib/ -follow -type f -name '*.pyc' -delete \
    && find /usr/lib/ -follow -type f -name '*.js.map' -delete \
    && find /opt/intel/ -name "*.tgz*" | xargs rm -rf || true \
    && find /opt/intel/ -name "*.tar.bz2*" | xargs rm -rf || true \
    && find /opt/intel/ -name "*.log" | xargs rm -rf || true \
    && find /opt/intel/ -type d -name "benchmark*" | xargs rm -rf \
    && find /opt/intel/oneapi/mkl/ -name "*.a" | xargs rm -rf || true \
    && find /opt/intel/oneapi/mpi/latest/lib/release -name "*.a" | xargs rm -rf || true \
    && rm -rf /opt/intel/oneapi/intelpython/ || true \
    && rm -rf /opt/intel/oneapi/conda_channel/ || true \
    && rm -rf /opt/intel/oneapi/dal/ || true \
    && rm -rf /opt/intel/oneapi/ipp/ || true \
    && rm -rf /opt/intel/oneapi/dev-utilities/ || true \
    && rm -rf /opt/intel/oneapi/mpi/latest/lib/debug* \
    && rm -rf /opt/intel/oneapi/mpi/latest/lib/release_mt \
    && rm -rf /opt/intel/oneapi/compiler/2021.1.2/linux/lib/oclfpga/ \
    && dnf clean all

SHELL ["/bin/bash",  "-c"]
