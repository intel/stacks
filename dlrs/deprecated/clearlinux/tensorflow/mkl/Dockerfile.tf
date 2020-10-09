#---------------------------------------------------------------------
# Base instance to build MKL based Tensorflow on Clear Linux
#---------------------------------------------------------------------
FROM stacks-mkl-builder
LABEL maintainer=otc-swstacks@intel.com

RUN ./scripts/install_tensorflow.sh
