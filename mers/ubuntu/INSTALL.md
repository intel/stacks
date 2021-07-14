# Media Reference Stack - Ubuntu*

The Media Reference Stack (MeRS) is a highly optimized software stack for Intel® Architecture Processors (the CPU) and Intel® Processor Graphics (the GPU) to enable media prioritized transcode and analytics workloads, such as smart city applications, immersive media enhancement, video
surveillance, and product placement.

## Building container image

The Dockerfiles for all Intel System Stacks container images are available at
[stacks repository](https://github.com/intel/stacks). These can be used to
build and modify the media image at [MeRS](https://github.com/intel/stacks/tree/master/mers/ubuntu)

```bash
docker build --no-cache -t sysstacks/mers-ubuntu .
```

> **Note:**
     Default build args in Docker are on: https://docs.docker.com/engine/reference/builder/#arg

## Getting MeRS pre-built image

In case you want to pull the image directly instead of building it, official
images are located at docker hub so it can be pulled with the following command

```bash
docker pull sysstacks/mers-ubuntu
```

## Running the Media Container

Once you have the Media Reference Stack image, run it with

```bash
docker run -it --rm \
sysstacks/mers-ubuntu
```

## Run examples

For transcoding and video analytics examples and pipelines, please see the
official documentation on the Intel® oneContainer Portal at the [Get Started Guide](https://software.intel.com/content/www/us/en/develop/articles/containers/media-reference-stack-on-ubuntu.html?wapkw=mers)


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
[Vulnerability handling guidelines](https://www.intel.com/content/www/us/en/security-center/vulnerability-handling-guidelines.html)

## LEGAL NOTICE

By accessing, downloading or using this software and any required dependent software (the “Software Package”), you agree to the terms and conditions of the software license agreements for the Software Package, which may also include notices, disclaimers, or license terms for third party software included with the Software Package. Please refer to (https://github.com/intel/stacks/blob/master/mers/LICENSES.md).

Intel and the Intel logo are trademarks of Intel Corporation or its subsidiaries

\Other names and brands may be claimed as the property of others*
