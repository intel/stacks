#!/bin/bash
#
# Copyright (c) 2019 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

printf "\nSet default runtime  params when using Intel® DLRS stack.\n"
printf "We recommend you fine tune the exported env variables based on the workload\n"
printf "More details can be found at: https://github.com/IntelAI/models/blob/master/docs/general/tensorflow_serving/GeneralBestPractices.md\n\n"

run () {
  line_length=$(echo "$@" | awk '{print length}')
  printf "%$((line_length+35))s\n" |tr " " "="
  printf "$(date) -- %s"
  printf "%s\n" "$@"
  printf "%$((line_length+35))s\n" |tr " " "="
}

system_stat () {
  # A good default setting for OMP theads is number of physical cores
  physical_cores=$(lscpu | grep 'Core(s)' | head -1 | awk '{print $4}')
  cores_per_sockets=$(lscpu | grep 'Core(s) per socket' | head -1 | awk '{print $4}')
  sockets=$(lscpu | grep 'Socket(s)' | head -1 | awk '{print $2}')
  total_physical_cores=$((physical_cores * sockets))
}

serving_variables () {
  export OMP_NUM_THREADS=$total_physical_cores
  export KMP_BLOCKTIME=2
  export KMP_AFFINITY=granularity=fine,verbose,compact,1,0
  export INTRA_OP_PARALLELISM_THREADS=$total_physical_cores
  export INTER_OP_PARALLELISM_THREADS=$((physical_cores * cores_per_sockets))
  # tensorflow specific configurations
  export TENSORFLOW_INTRA_OP_PARALLELISM=$INTRA_OP_PARALLELISM_THREADS
  export TENSORFLOW_INTER_OP_PARALLELISM=$INTER_OP_PARALLELISM_THREADS
}

vision_models_variables () {
  export BATCH_SIZE=128
  export DATA_LAYOUT=NCHW
  export KMP_BLOCKTIME=2
  export OMP_NUM_THREADS=$cores_per_sockets
  export KMP_AFFINITY=granularity=fine,verbose,compact,1,0
  export INTRA_OP_PARALLELISM_THREADS=$cores_per_sockets
  export INTER_OP_PARALLELISM_THREADS=$sockets
  # tensorflow specific configurations
  export TENSORFLOW_INTRA_OP_PARALLELISM=$INTRA_OP_PARALLELISM_THREADS
  export TENSORFLOW_INTER_OP_PARALLELISM=$INTER_OP_PARALLELISM_THREADS
}

resnet101_model_variables () {
  export BATCH_SIZE=128
  export DATA_LAYOUT=NCHW
  export OMP_NUM_THREADS=$physical_cores
  export KMP_BLOCKTIME=2
  export KMP_AFFINITY=granularity=fine,verbose,compact,1,0
  export INTRA_OP_PARALLELISM_THREADS=$total_physical_cores
  export INTER_OP_PARALLELISM_THREADS=$sockets
  # tensorflow specific configurations
  export TENSORFLOW_INTRA_OP_PARALLELISM=$INTRA_OP_PARALLELISM_THREADS
  export TENSORFLOW_INTER_OP_PARALLELISM=$INTER_OP_PARALLELISM_THREADS
}

wide_deep_models_variables () {
  export BATCH_SIZE=64
  export DATA_LAYOUT=NCHW
  export OMP_NUM_THREADS=$total_physical_cores
  export KMP_BLOCKTIME=1
  export KMP_AFFINITY=granularity=fine,verbose,compact,1,0
  export INTER_OP_PARALLELISM_THREADS=$physical_cores
  export INTRA_OP_PARALLELISM_THREADS=$sockets
  # tensorflow specific configurations
  export TENSORFLOW_INTRA_OP_PARALLELISM=$INTRA_OP_PARALLELISM_THREADS
  export TENSORFLOW_INTER_OP_PARALLELISM=$INTER_OP_PARALLELISM_THREADS
}


language_models_variables () {
  unset DATA_LAYOUT
  export BATCH_SIZE=512
  export OMP_NUM_THREADS=$physical_cores
  export KMP_BLOCKTIME=1
  export KMP_AFFINITY=granularity=fine,verbose,compact,1,0
  export INTRA_OP_PARALLELISM_THREADS=$physical_cores
  export INTER_OP_PARALLELISM_THREADS=$sockets
  # tensorflow specific configurations
  export TENSORFLOW_INTRA_OP_PARALLELISM=$INTRA_OP_PARALLELISM_THREADS
  export TENSORFLOW_INTER_OP_PARALLELISM=$INTER_OP_PARALLELISM_THREADS
}

default_variables () {
  unset BATCH_SIZE
  unset DATA_LAYOUT
  export OMP_NUM_THREADS=$physical_cores
  export KMP_BLOCKTIME=1
  export KMP_AFFINITY=granularity=fine,verbose,compact,1,0
  export INTRA_OP_PARALLELISM_THREADS=$physical_cores
  export INTER_OP_PARALLELISM_THREADS=2
  # tensorflow specific configurations
  export TENSORFLOW_INTRA_OP_PARALLELISM=$INTRA_OP_PARALLELISM_THREADS
  export TENSORFLOW_INTER_OP_PARALLELISM=$INTER_OP_PARALLELISM_THREADS
}

# start here
system_stat
echo "Supported models"
echo "- vision"
echo "- resnet101"
echo "- langauge"
echo "- wide_deep"
echo "- default"

printf "\nWhat type of model are you trying to run?"
read -r model

case $model  in
  default)
    run "Setting default params" && default_variables
    ;;
  language)
    run "Setting default params for language models" && language_models_variables
    ;;
  resnet101)
    run "Setting default params for resnet101" && resnet101_model_variables
    ;;
  vision)
    run "Setting default params for vision models" && vision_models_variables
    ;;
  wide_deep)
    run "Setting default params for wide_deep models" && wide_deep_models_variables
    ;;
  *)
    run "No valid model type given"
esac

print_params() {
  [[ -n "$BATCH_SIZE" ]] && printf "BATCH_SIZE :: %s\n" $BATCH_SIZE
  [[ -n "$DATA_LAYOUT" ]] && printf "DATA_LAYOUT :: %s\n" $DATA_LAYOUT
  echo "OMP_NUM_THREADS :: $OMP_NUM_THREADS"
  echo "KMP_BLOCKTIME :: $KMP_BLOCKTIME"
  echo "KMP_AFFINITY :: $KMP_AFFINITY"
  echo "INTER_OP_PARALLELISM_THREADS :: $INTER_OP_PARALLELISM_THREADS"
  echo "INTRA_OP_PARALLELISM_THREADS :: $INTRA_OP_PARALLELISM_THREADS"
  echo "TENSORFLOW_INTRA_OP_PARALLELISM :: $TENSORFLOW_INTRA_OP_PARALLELISM" 
  echo "TENSORFLOW_INTER_OP_PARALLELISM :: $TENSORFLOW_INTER_OP_PARALLELISM"
}
run " Parameters Set" && print_params
