#---------------------------------------------------------------------
# ML Compilers on Clear Linux
#---------------------------------------------------------------------
ARG clear_ver
FROM clearlinux/stacks-clearlinux:$clear_ver
LABEL maintainer=otc-swstacks@intel.com

# update os and add required bundles
RUN swupd bundle-add git wget \
    python3-basic llvm c-basic \
    && rm -rf /var/lib/swupd/*

# library linking fix
RUN cd /usr/lib64 \
    && ln -sf libstdc++.so.6.0.2* libstdc++.so.6 \
    && ln -sf libzstd.so.1.4.* libzstd.so.1

# build mkl, install dl libs and tvm
COPY ./scripts/ /scripts
RUN ./scripts/install_mkl.sh \
    && ./scripts/install_tvm.sh

# this will install popular dl libs like TensorFlow,
# uncomment this line, if you need the frameworks to be prebuilt
# (fixme): add a Readme informing user about this
#RUN ./scripts/install_dl_frontends.sh 
# init
WORKDIR /workspace
RUN echo "export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib64:/usr/lib:/usr/lib32" >> /.bashrc \
  && echo "export PYTHONPATH=/tvm/python:/tvm/topi/python:/tvm/nnvm/python/:/tvm/vta/python" >> /.bashrc \
  && chmod -R a+w /workspace
SHELL ["/bin/bash", "-c", "source /.bashrc"]

