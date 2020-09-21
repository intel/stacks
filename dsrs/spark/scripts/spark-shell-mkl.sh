#!/bin/bash
# spark-shell with mkl enabled, to verify MKL is enabled:
# On spark-shell:
#                    import com.github.fommil.netlib.BLAS 
#                    println(BLAS.getInstance().getClass().getName())
MKL_WRAPPER="/opt/intel/mkl/wrapper/mkl_wrapper.jar"
JAVA_OPTIONS="-Dcom.github.fommil.netlib.BLAS=com.intel.mkl.MKLBLAS -Dcom.github.fommil.netlib.LAPACK=com.intel.mkl.MKLLAPACK"

spark-shell --conf "spark.executor.extraClassPath=$MKL_WRAPPER" --conf "spark.driver.extraClassPath=$MKL_WRAPPER" --conf "spark.executor.extraJavaOptions=$JAVA_OPTIONS" --conf "spark.driver.extraJavaOptions=$JAVA_OPTIONS"
