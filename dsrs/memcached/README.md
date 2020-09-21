# Data Services Reference Stack(DSRS) - Memcached 

DSRS Memcached is packaged as a Docker container based on CentOS 8 and a set of scripts to build components including: 

- [Memcached with persistent memory support](https://www.memcached.org)

## Source code

The latest source code and documentation related to build and deploy the image can be found here:

- [https://github.com/intel/stacks](https://github.com/intel/stacks)

## DSRS Memcached Stack

"Free & open source, high-performance, distributed memory object caching system" (https://memcached.org/). Stack ready to use DCPMM in fsdax mode for storage.

The source code used for this application can be found in the [Memcached repository](https://memcached.org/). Be sure to checkout at least v1.5.18.

## Build DSRS Memcached image

To build an image by yourself, install the docker dependencies and run the following command:

```bash
docker build --force-rm --no-cache -f Dockerfile -t ${DOCKER_IMAGE} .
```

## Run DSRS Memcached as a standalone container

Prior to start the application, you will need to have the PMem in fsdax mode with a file system and mounted in `/mnt/dax0`. To know how to configure, read the [documentation of DSRS](../README.md#configuration-steps)

To start the application

```bash
docker run --mount type=bind,source=/mnt/dax0,target=/mnt/pmem0 -i -d --name pmem-memcached ${DOCKER_IMAGE} -e /mnt/pmem0/memcached.file -m 64 -c 1024 -p 11211
```

where:

* '-m' max memory limit to use in megabytes.

* '-e' mmap path for external memory (PMem storage), for this container PMem should be mounted inside the container on /mnt/pmem0

* '-c' number of concurrent connections

* '-p' is the listening TCP connection port.

For more information please visit: https://memcached.org/blog/persistent-memory/

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

*\*Other names and brands may be claimed as the property of others*

