#!/bin/bash
# spark-submit examples, spark on yarn and spark with openblas
JAR_EXAMPLES="/opt/spark-3.0.2/examples/target/original-spark-examples_2.12-3.0.2.jar"
JAVA_OPTIONS="-Dcom.github.fommil.netlib.BLAS=com.github.fommil.netlib.NativeSystemBLAS -Dcom.github.fommil.netlib.LAPACK=com.github.fommil.netlib.NativeSystemLAPACK -Dcom.github.fommil.netlib.ARPACK=com.github.fommil.netlib.NativeSystemARPACK"
TEST="--class org.apache.spark.examples.mllib.PCAOnRowMatrixExample"
PARAMS="--num-executors 1 --executor-memory 2G --executor-cores 1"


# Spark with OpenBLAS enabled
echo -e "\n"
echo "Spark with OpenBLAS enabled"
spark-submit $TEST $PARAMS \
--conf "spark.executor.extraJavaOptions=$JAVA_OPTIONS" \
--conf "spark.driver.extraJavaOptions=$JAVA_OPTIONS" \
$JAR_EXAMPLES 



