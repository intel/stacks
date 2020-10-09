#---------------------------------------------------------------------
# Base instance to build MKL based Tensorflow 2.0 on Clear Linux
#---------------------------------------------------------------------
FROM stacks-mkl-builder
LABEL maintainer=otc-swstacks@intel.com

RUN ./scripts/install_tensorflow_2.0.sh
