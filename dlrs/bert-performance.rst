.. _bert-performance:

State-of-the-art BERT Fine-tune training and Inference
######################################################

.. contents::
   :local:
   :depth: 1

Overview
********

Driven by real-life use cases ranging from medical diagnostics to financial fraud detection, deep learning’s neural networks are growing in size and complexity as more and more data is available to be consumed. This influx of data allows for more accuracy in data scoring, which can result in better AI models, but presents challenges to compute performance.  To  help keep up with the computational power required to run the deep learning workloads,  Google came up with the BFLOAT16 format to increase performance on their Tensor Processing Units (TPUs).

BFLOAT16 uses one bit for sign, eight for exponent, and seven for mantissa. Due to its dynamic range, it can be used to represent gradients directly without the need for loss scaling. It has been shown that the BFLOAT16 format works as well as the FP32 format while delivering increased performance and reducing memory usage.

Intel’s 3rd Gen Intel® Xeon® Scalable processor, featuring Intel® Deep Learning Boost, is the first general-purpose x86 CPU to support the BFLOAT16 format.

The latest Deep Learning Reference Stack (DLRS) 7.0 release integrated Intel optimized TensorFlow, which enables BFLOAT16 support for servers with the 3rd Gen Intel® Xeon® Scalable processor. Now AI developers can quickly develop, iterate and run BFLOAT16 models directly by utilizing the DLRS stack.

In this guide we walk through a solution to set up your infrastructure and deploy a BERT fine tune training and inference workload using the DLRS containers from Intel.

Recommended Hardware
********************

We recommend a 3rd Generation Intel Xeon Scalable processor to get the optimal performance and take advantage of the built in Intel® Deep Learning Boost (Intel® DL Boost) and BFLOAT16(BF16) extension functionality.

Required Software
*****************

* Install Ubuntu* 20.04 Linux OS on your host system
* Install Docker* Engine

Steps
*****

#. Download the DLRS v0.7.0 Image and launch it in interactive mode

   .. code-block:: bash

      docker pull sysstacks/dlrs-tensorflow2-ubuntu:v0.7.0-intel-tf
      docker run -it --shm-size 8g --security-opt[4] [5] [6]   seccomp=unconfined sysstacks/dlrs-tensorflow2-ubuntu:v0.7.0-intel-tf bash

#. At the container shell prompt, run the following command to install required tools

   .. code-block:: bash

      apt-get update
      apt-get install wget unzip git

Run BERT Fine-tune training with the Squad 1.1 data set
*******************************************************

#. Download wwm_cased_L-24_H-1024_A-16.zip, which contains a pre-trained Bert model with 24 layers, 1024 hidden units, and 16 attention heads. The model has been trained with the whole word masked using a wordpiece tokenized by Google.

   .. code-block:: bash

      wget https://storage.googleapis.com/bert_models/2019_05_30/wwm_cased_L-24_H-1024_A-16.zip -P /tmp
      unzip /tmp/wwm_cased_L-24_H-1024_A-16.zip -d /tmp

#. Download the Squad 1.1 dataset. This reading comprehension dataset consists of questions posed on a set of Wikipedia articles, where the answer to every question is in the corresponding passage. SQuAD 1.1 contains 100,000+ question-answer pairs on 500+ articles

   .. code-block:: bash

      wget https://rajpurkar.github.io/SQuAD-explorer/dataset/train-v1.1.json -P /tmp
      wget https://rajpurkar.github.io/SQuAD-explorer/dataset/dev-v1.1.json -P /tmp
      wget https://github.com/allenai/bi-att-flow/blob/master/squad/evaluate-v1.1.py -P /tmp

#. Download the Model Zoo for Intel® Architecture. The Intel Model Zoo* contains links to pre-trained models, sample scripts, best practices, and step-by-step tutorials for many popular open-source machine learning models optimized by Intel to run on Intel® Xeon® Scalable processors. We use the Model Zoo script to run the BERT Fine-tune training and Inference

   .. code-block:: bash

      git clone -b v1.6.1 https://github.com/IntelAI/models /tmp/models

#. Change PYTHONPATH to include model zoo benchmark directory

   .. code-block:: bash

      export PYTHONPATH=$PYTHONPATH:/tmp/models/benchmarks

#. Run Bert fine-tune training with Squad 1.1 data set.  Note that these parameters are subject to change according to your hardware requirements.

   .. code-block:: bash

      python3 /tmp/models/benchmarks/launch_benchmark.py \
      --model-name=bert_large \
      --precision=bfloat16 \
      --mode=training \
      --mpi_num_processes=4 \
      --mpi_num_processes_per_socket=1 \
      --num-intra-threads=22 \
      --num-inter-threads=1 \
      --output-dir=/tmp/SQuAD_1.1_fine_tune \
      --framework=tensorflow \
      --batch-size=24 \
      -- train_option=SQuAD \
      vocab_file=/tmp/wwm_cased_L-24_H-1024_A-16/vocab.txt \
      config_file=/tmp/wwm_cased_L-24_H-1024_A-16/bert_config.json \
      init_checkpoint=/tmp/wwm_cased_L-24_H-1024_A-16/bert_model.ckpt \
      do_train=True \
      train_file=/tmp/train-v1.1.json \
      do_predict=True \
      predict_file=/tmp/dev-v1.1.json \
      learning_rate=1.5e-5  \
      num_train_epochs=2 \
      warmup-steps=0 \
      doc_stride=128 \
      do_lower_case=False \
      max_seq_length=384 \
      experimental_gelu=True \
      optimized-softmax=True \
      mpi_workers_sync_gradients=True

#. Run BERT Inference with the Squad 1.1 data set

   * Download the pre-trained BERT Large Model

       .. code-block:: bash

          wget https://storage.googleapis.com/bert_models/2019_05_30/wwm_uncased_L-24_H-1024_A-16.zip -P /tmp
          unzip /tmp/wwm_uncased_L-24_H-1024_A-16.zip -d /tmp

   * For BERT Inference, we will use the Intel optimized check point directly

       .. code-block:: bash

          wget https://storage.googleapis.com/intel-optimized-tensorflow/models/v1_6_1/bert_large_checkpoints.zip -P /tmp
          unzip /tmp/bert_large_checkpoints.zip -d /tmp

#. Download the Squad 1.1 data set to the BERT Large Model directory

   .. code-block:: bash

      wget https://rajpurkar.github.io/SQuAD-explorer/dataset/dev-v1.1.json -P /tmp/wwm_uncased_L-24_H-1024_A-16

#. Run BERT Inference with following command

   .. code-block:: bash

      numactl --localalloc --physcpubind=0-27 python3 /tmp/models/benchmarks/launch_benchmark.py \
       --model-name=bert_large \
       --precision=bfloat16 \
       --mode=inference \
      --framework=tensorflow \
      --num-inter-threads 1 \
      --num-intra-threads 28 \
      --batch-size=32 \
      --data-location /tmp/wwm_uncased_L-24_H-1024_A-16 \
      --checkpoint /tmp/bert_large_checkpoints \
      --output-dir /tmp/SQuAD_1.1_inference \
      --benchmark-only



NOTICES AND DISCLAIMERS
***********************

Performance varies by use, configuration and other factors. Learn more at www.Intel.com/PerformanceIndex.
Performance results are based on testing as of dates shown in configurations and may not reflect all publicly available updates.  See backup for configuration details.  No product or component can be absolutely secure.
Your costs and results may vary.
Intel technologies may require enabled hardware, software or service activation.
© Intel Corporation.  Intel, the Intel logo, and other Intel marks are trademarks of Intel Corporation or its subsidiaries.  Other names and brands may be claimed as the property of others.
