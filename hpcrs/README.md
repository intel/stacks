# High Performance Compute Reference Stack

The High Performance Computing Reference Stack (HPCRS) meets the needs of
deploying HPC and AI workloads on the same system. This software solution
reduces the complexities associated with integrating software components for
High Performance Computing (HPC) workloads.

This guide explains how to use the pre-built HPCRS container image, build
your own HPCRS container image, and use the reference stack.https://github.com/intel/stacks/blob/master/hpcrs/NEWS.md

## Overview

HPCRS abstracts away the complexity of integrating multiple performance oriented
software components including compilers, libraries, and frameworks. HPCRS
enables users and developers of HPC and AI workloads to accomplish their work
using a simple containerized solution.

## Releases

Refer to the [System Stacks for Linux* OS
repository](https://github.com/intel/stacks) for information and download links
for the different versions and offerings of the stack.

* HPCRS v0.2.0 includes a pre-built container based on CentOS
  integrating proprietary software components for single-node usage.

* [HPCRS Release notes on
  GitHub*](https://github.com/intel/stacks/blob/master/hpcrs/NEWS.md)
  for the latest release of HPCRS.

### Prerequisites

HPCRS can run on any host system running Linux which supports Intel® Advanced
Vector Extensions 512 (Intel® AVX-512) and Docker\*. This guide uses CentOS
Linux* OS as the host system.

- Docker


## Stack features

The HPCRS provides a pre-built Docker image, which includes instructions on
building the image from source. HPCRS is open-sourced to make sure developers
have easy access to the source code and are able to customize it.

HPCRS provides the following software components:

  - [CentOS](https://https://www.centos.org) as the base image
  - [PyTorch*](https://pytorch.org/)
  - [Horovod*](https://github.com/horovod/horovod)
  - [OpenMP*](https://www.openmp.org/)
  - [Intel® MPI Library](https://software.intel.com/content/www/us/en/develop/tools/mpi-library.html)
  - [Intel® C++ Compiler](https://software.intel.com/content/www/us/en/develop/tools/compilers/c-compilers.html)
  - [Intel® Fortran Compiler](https://software.intel.com/content/www/us/en/develop/tools/compilers/fortran-compilers.html)
  - [Intel® Math Kernel Library](https://software.intel.com/content/www/us/en/develop/tools/math-kernel-library.html>)
  - [Intel® Data Parallel C++](https://software.intel.com/content/www/us/en/develop/documentation/oneapi-programming-guide/top/data-parallel-c-dpc.html)
  - [Intel® oneAPI Collective Communications Library](https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/oneccl.html)
  - [Intel® oneAPI Threading BUilding Blocks](https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/onetbb.html)
  - [libfabric](https://github.com/ofiwg/libfabric/)
  - [Spack](https://spack.io/)

---
NOTE:

Please see the [third party program file](./licenses/third-party-programs.txt) and [README](./README.md) text.

---


## Get the pre-built HPCRS container image

Pre-built HPCRS Docker images are available. To use the HPCRS:

1. Pull the image:

   `docker pull sysstacks/hpcrs-centos`

   ---
   NOTE:

      If you are on a network with outbound proxies, be sure to configure Docker
      to allow access. See the [Docker service
      proxy](https://docs.docker.com/config/daemon/systemd/#httphttps-proxy) and
      [Docker client
      proxy](https://docs.docker.com/network/proxy/#configure-the-docker-client)
      documentation for more details.

   ---
2. Once you have downloaded the image, run it using the following command:

   `docker run -it sysstacks/hpcrs-centos`

   This will launch the image and drop you into a bash shell inside the
   container in the `/workspace` folder.

   Paths from the host can be shared to the container with the `--volume` switch
   [using Docker volumes](https://docs.docker.com/storage/volumes/).


## Build the HPCRS container image from source

If you choose to build your own HPCRS container image, you can optionally add
customizations as needed. The `Dockerfile` for the HPCRS is available on
[GitHub](https://github.com/intel/stacks/blob/master/hpcrs/Dockerfile) and can be used as a
reference when creating your own container image.

1. Clone the `hpcrs` repository.

   `git clone https://github.com/intel/stacks.git`

2. Navigate to the `stacks/hpcrs` directory which contains the
   Dockerfile for the HPCRS.

   `cd ./stacks/hpcrs`

3. Use the `make` to build the HPCRS container image. The
   `make` target will run the appropriate `docker build`
   command.

   `make build`


## Use the HPCRS container image

This section shows examples of how the HPCRS container image can be used.


### PyTorch benchmarks

This section describes running the [PyTorch
benchmarks](https://github.com/pytorch/benchmark) for Caffe2 in single node.

1. [Get the pre-built HPCRS container image](#get-the-pre-built-hpcrs-container-image)

1. Run the image with Docker:

   `docker run --name <image name>  --rm -i -t sysstacks/hpcrs-centos /bin/bash`

   ---
   NOTE:

   Launching the Docker image with the `-i` argument starts
   interactive mode within the container. Enter the following commands in
   the running container.

   ---

1. Navigate to to where Pytorch and Caffe are installed:

   `cd /usr/lib/python3.8/site-packages/caffe2/python/`

1. Install dependencies for the benchmark:

   ```bash
   pip install protobuf
   pip install future
   ```

1. Execute the benchmark script:

   ```bash
   python convnet_benchmarks.py --batch_size 32 \
                                --cpu \
                                --model AlexNet
   ```

*Intel and the Intel logo are trademarks of Intel Corporation or its
subsidiaries.*


## Convert the HPCRS image to a Singularity image

You may want to run the HPCRS image on Singularity for HPC workloads. A tool is
available to easily convert the HPCRS Docker image to a Singularity image.

Refer to the README.md file in the d2s directory.


## Reporting Security Issues

If you have discovered potential security vulnerability in an Intel product,
please contact the iPSIRT at secure@intel.com.

It is important to include the following details:

  * The products and versions affected
  * Detailed description of the vulnerability
  * Information on known exploits

Vulnerability information is extremely sensitive. The iPSIRT strongly recommends
that all security vulnerability reports sent to Intel be encrypted using the
iPSIRT PGP key. The PGP key is available here:
https://www.intel.com/content/www/us/en/security-center/pgp-public-key.html

Software to encrypt messages may be obtained from:

  * PGP Corporation
  * GnuPG

For more information on how Intel works to resolve security issues, see:
[Vulnerability handling
guidelines](https://www.intel.com/content/www/us/en/security-center/vulnerability-handling-guidelines.html)

## LEGAL NOTICE
By accessing, downloading or using this software and any required dependent software (the “Software Package”), you agree to the terms and conditions of the software license agreements for the Software Package, which may also include notices, disclaimers, or license terms for third party software included with the Software Package. Please refer to the “third-party-programs.txt” or other similarly-named text file for additional details.

*Intel and the Intel logo are trademarks of Intel Corporation or its
subsidiaries*

*\*Other names and brands may be claimed as the property of others.*
