#!/bin/bash
# spark-submit examples, spark on yarn and spark with openblas
JAR_EXAMPLES="/opt/spark-3.0.0/examples/target/original-spark-examples_2.12-3.0.0.jar"
JAVA_OPTIONS="-Dcom.github.fommil.netlib.BLAS=com.github.fommil.netlib.NativeSystemBLAS -Dcom.github.fommil.netlib.LAPACK=com.github.fommil.netlib.NativeSystemLAPACK -Dcom.github.fommil.netlib.ARPACK=com.github.fommil.netlib.NativeSystemARPACK"
TEST="--class org.apache.spark.examples.mllib.PCAOnRowMatrixExample"
PARAMS="--num-executors 1 --executor-memory 1G --executor-cores 1"
declare -i ret=-1

record() {
  for i in {1..10}
  do
    mapfile -t pids < <(pgrep java)
    for (( i=0; i<${#pids[@]}; i++ ))
    do
      PID=${pids[i]}
      CMND=$(ps -p $PID)
      cat /proc/$PID/maps | grep 'libmkl' &> /dev/null
      if [ $? == 0 ]; then
        ret=0
        break
      fi
    done
    sleep 1
  done

  if [ $ret -ne 0 ]; then
    echo -e "\nNo MKL libraries found while spark benchmark was running"
  else
    echo -e "MKL libraries found Ok"
  fi
}

# Spark with YARN 
echo -e "\n\n\n\n\n"
echo "Spark on YARN with OpenBLAS"
spark-submit $TEST $PARAMS \
--master yarn \
--deploy-mode client \
--conf "spark.executor.extraJavaOptions=$JAVA_OPTIONS" \
--conf "spark.driver.extraJavaOptions=$JAVA_OPTIONS" \
$JAR_EXAMPLES



# Spark with OpenBLAS enabled
echo -e "\n\n\n\n\n"
echo "Spark with OpenBLAS enabled"
spark-submit $TEST $PARAMS \
--conf "spark.executor.extraJavaOptions=$JAVA_OPTIONS" \
--conf "spark.driver.extraJavaOptions=$JAVA_OPTIONS" \
$JAR_EXAMPLES 



