# Deep Learning Reference Stack

The Deep Learning Reference Stack, an integrated, highly-performant open source stack optimized for Intel® Xeon® Scalable platforms. This open source community release is part of our effort to ensure AI developers have easy access to all of the features and functionality of the Intel platforms.  The Deep Learning Reference Stack is highly-tuned and built for cloud native environments. With this stack, we are enabling developers to quickly prototype by reducing the complexity associated with integrating multiple software components, while still giving users the flexibility to customize their solutions. This version includes additional components to provide greater flexibility and a more comprehensive take on the deep learning environment.

# The Deep Learning Reference Stack Release

To offer more flexibility, we are releasing multiple versions of the Deep Learning Reference Stack. All versions are built on top of the Clear Linux OS, which is optimized for IA.

> **Note:**
     The minimum validated version of Clear Linux for this stack is 31290.

## The Deep Learning Reference Stack with Tensorflow 2.0, Intel® MKL-DNN and Intel® AVX512-Deep Learning Boost

The release includes:
  * Clear Linux* OS
  * Runtimes (python)
  * TensorFlow 2.0 optimized using Intel® Math Kernel Library for Deep Neural Networks (Intel® MKL-DNN) primitives and Intel® AVX-512 Deep Learning Boost (Formerly Intel® VNNI)
  * Intel OpenVINO model server v2019_R3
  * Transformers - State-of-the-art Natural Language Processing for TensorFlow 2.0

## The Deep Learning Reference Stack with Tensorflow 1.15, Intel® MKL-DNN and Intel® AVX512-Deep Learning Boost

The release includes:
  * Clear Linux* OS
  * Runtimes (python)
  * TensorFlow 1.15 optimized using Intel® Math Kernel Library for Deep Neural Networks (Intel® MKL-DNN) primitives and Intel® AVX-512 Deep Learning Boost (Formerly Intel® VNNI)
  * Intel OpenVINO model server v2019_R3

## The Deep Learning Reference Stack with Eigen

The release includes:
  * Clear Linux* OS
  * TensorFlow 1.14 compiled with AVX2 and AVX512 optimizations
  * Runtimes (python)

> **Note:**
   When using the Deep Learning Reference Stack with Intel®  MKL-DNN version, you may see this warning message: "tensorflow/core/platform/cpu_feature_guard.cc:141] Your CPU supports instructions that this TensorFlow binary was not compiled to use: SSE4.1 SSE4.2 AVX AVX2 AVX512F FMA". This is because this version of the Deep Learning Reference Stack is using Intel®  MKL-DNN for performance optimization rather than Intel®  Advanced Vector Extensions 512, and is expected for this version of the Deep Learning Reference Stack.

## The Deep Learning Reference Stack with PyTorch and Intel® MKL

The release includes:
 * Clear Linux* OS
 * Runtimes (python)
 * PyTorch optimized using the Intel® Math Kernel Library
 * PyTorch lightning
 * Flair for Natural Language Processing

## The Deep Learning Reference Stack with PyTorch

The release includes:
 * Clear Linux* OS
 * Runtimes (python)
 * PyTorch with OpenBlAS

## Deep Learning Compilers

The release includes:
 * TVM 0.6

## How to get the Deep Learning Reference Stack

The official Deep Learning Reference Stack Docker images are hosted at: https://hub.docker.com/u/clearlinux/.  Note that the Intel MKL-DNN-VNNI version is also referred to as the Intel® MKL with AVX-512 Deep Learning Boost in the documentation. 

 * Pull from the [Tensroflow 1.15 and Intel MKL-DNN version](https://hub.docker.com/r/clearlinux/stacks-dlrs-mkl/)
 * Pull from the [Tensorflow 2.0 and Intel MKL-DNN version](https://hub.docker.com/r/clearlinux/stacks-dlrs_2-mkl/)
 * Pull from the [Eigen version](https://hub.docker.com/r/clearlinux/stacks-dlrs-oss/)
 * Pull from the [PyTorch with Intel MKL-DNN version](https://hub.docker.com/r/clearlinux/stacks-pytorch-mkl)
 * Pull from the [PyTorch with OpenBLAS version](https://hub.docker.com/r/clearlinux/stacks-pytorch-oss)
 * Pull from the [ML Compiler](https://hub.docker.com/r/clearlinux/stacks-ml-compiler)


**Note:**
   To take advantage of the AVX-512, and AVX-512 Deep Learning Boost functionality with the Deep Learning Reference Stack, please use the following hardware:
     * AVX 512 images requires an Intel® Xeon® Scalable Platform
     * AVX-512 Deep Learning Boost requires a Second-Generation Intel® Xeon® Scalable Platform


## Licensing


The Deep Learning Reference Stack is guided by the same [Terms of Use](https://download.clearlinux.org/TermsOfUse.html) declared by the Clear Linux project. The Docker images are hosted on https://hub.docker.com and as with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc. from the base distribution, along with any direct or indirect dependencies of the primary software being contained).



# Working with the Deep Learning Reference Stack


The Deep Learning Reference Stack includes TensorFlow and Kubeflow support.
These software components were selected because they are most popular/widely used by developers and CSPs. Clear Linux provides optimizations across the entire OS stack for the ultimate end user performance and is customizable to meet your unique needs. TensorFlow was selected as it is the leading deep learning and machine learning framework. Intel® Math Kernel Library for Deep Neural Networks (Intel® MKL-DNN) is an open source performance library for Deep Learning (DL) applications intended for acceleration of DL frameworks on Intel® architecture. Intel® MKL-DNN includes highly vectorized and threaded building blocks to implement convolutional neural networks (CNN) with C and C++ interfaces.  Kubeflow  is a project that provides a straightforward way to deploy simple, scalable and portable Machine Learning workflows on Kubernetes. This combination of an operating system, the deep learning framework and libraries, results in a performant deep learning software stack.

Please refer to the [Deep Learning tutorial](https://clearlinux.org/documentation/clear-linux/tutorials/dlrs) for detailed instructions for running the TensorFlow and Kubeflow Benchmarks on the docker images.

## Performance tuning configurations

### Single Node Configuration

| Key | Value |
| ----------------- | ------------- |
| num_inter_threads | Socket number |
| num_intra_threads | Physical cores number |
| data_format       |  NHWC for Eigen; NCHW for MKL as MKL is optimized for this format |


Example: For Intel® Xeon® Gold 6140 CPU @ 2.30GHz with 2 Sockets and 18 Cores/Socket MKL training with batch size 32:

```
  python tf_cnn_benchmarks.py --device=cpu --mkl=True --nodistortions --model=resnet50 --data_format=NCHW --batch_size=32 --num_inter_threads=2 --num_intra_threads=36 --data_dir=/imagenet-TFrecord --data_name=imagenet
```
### Multi-node Configuration

The Deep Learning Reference Stack can be used in a multi node configuration using Kubernetes and different machine learning frameworks and libraries. Please refer to the System Stacks [usecases repo](https://github.com/intel/stacks-usecase) to find examples on how to setup the Deep Learning Reference Stack with Kubeflow for multi-node.

For multi-node training please refer to:

* [PyTorch multi-node using Kubeflow](link pending)
* [Tensorflow multi-node using Kubeflow](link pending)

# Contributing to the Deep Learning Reference Stack

We encourage your contributions to this project, through the established Clear Linux community tools.  Our team uses typical open source collaboration tools that are described on the Clear Linux [community page](https://clearlinux.org/community).

# Reporting Security Issues

  If you have discovered potential security vulnerability in an Intel product, please contact the iPSIRT at secure@intel.com.

  It is important to include the following details:

  * The products and versions affected
  * Detailed description of the vulnerability
  * Information on known exploits

  Vulnerability information is extremely sensitive. The iPSIRT strongly recommends that all security vulnerability reports sent to Intel be encrypted using the iPSIRT PGP key. The PGP key is available here: https://www.intel.com/content/www/us/en/security-center/pgp-public-key.html

  Software to encrypt messages may be obtained from:

  * PGP Corporation
  * GnuPG
