#!/bin/bash
set -xe
# spark-shell with openblas enabled, to verify that openblas is enabled:
# On spark-shell:
#                    import com.github.fommil.netlib.BLAS 
#                    println(BLAS.getInstance().getClass().getName())
JAVA_OPTIONS="-Dcom.github.fommil.netlib.BLAS=com.github.fommil.netlib.NativeSystemBLAS -Dcom.github.fommil.netlib.LAPACK=com.github.fommil.netlib.NativeSystemLAPACK -Dcom.github.fommil.netlib.ARPACK=com.github.fommil.netlib.NativeSystemARPACK"

spark-shell  --conf "spark.executor.extraJavaOptions=$JAVA_OPTIONS" --conf "spark.driver.extraJavaOptions=$JAVA_OPTIONS"
