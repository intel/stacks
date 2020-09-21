#!/bin/bash
# spark-submit examples, spark on yarn and spark with MKL
JAR_EXAMPLES="/opt/spark-3.0.0/examples/target/original-spark-examples_2.12-3.0.0.jar"
MKL_WRAPPER="/opt/intel/mkl/wrapper/mkl_wrapper.jar"
JAVA_OPTIONS="-Dcom.github.fommil.netlib.BLAS=com.intel.mkl.MKLBLAS -Dcom.github.fommil.netlib.LAPACK=com.intel.mkl.MKLLAPACK"
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

if [[ -z "$JAR_EXAMPLES" || -z "$MKL_WRAPPER" ]]; then
  echo "Error lack of any parameter: Jar examples path: $JAR_EXAMPLES Mkl wrapper path: $MKL_WRAPPER"
  exit $ret
fi


# Spark with YARN and MKL enabled
echo -e "\n\n\n\n\n"
echo "Spark with YARN and MKL enabled"
spark-submit $TEST $PARAMS \
--master yarn \
--deploy-mode client \
--conf "spark.executor.extraClassPath=$MKL_WRAPPER" \
--conf "spark.driver.extraClassPath=$MKL_WRAPPER" \
--conf "spark.executor.extraJavaOptions=$JAVA_OPTIONS" \
--conf "spark.driver.extraJavaOptions=$JAVA_OPTIONS" \
$JAR_EXAMPLES



# Spark with MKL enabled
echo -e "\n\n\n\n\n"
echo "Spark with MKL enabled"
spark-submit $TEST $PARAMS \
--conf "spark.executor.extraClassPath=$MKL_WRAPPER" \
--conf "spark.driver.extraClassPath=$MKL_WRAPPER" \
--conf "spark.executor.extraJavaOptions=$JAVA_OPTIONS" \
--conf "spark.driver.extraJavaOptions=$JAVA_OPTIONS" \
$JAR_EXAMPLES 



