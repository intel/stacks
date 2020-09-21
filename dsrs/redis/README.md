# Data Services Reference Stack(DSRS) - Redis 

DSRS Redis is packaged as a Docker container based on CentOS 8 and a set of scripts to build components including: 

- [Redis with persistent memory support](https://github.com/pmem/pmem-redis)

## Source code

The latest source code and documentation related to build and deploy the image can be found here:

- [https://github.com/intel/stacks](https://github.com/intel/stacks)


## DSRS Redis Stack

This project is a Redis stack enabled for multinode Kubernetes environment using PMem in fsdax mode for storage.

The source code used for this application can be found in the [Redis PMEM repository](https://github.com/pmem/pmem-redis)

You can lookup for image names executing the command `docker images`. This will list all your available images, if you don't have a DSRS Redis image, you can build one or download one.

## Build DSRS Redis image

To build an image by yourself, install the docker dependencies and run the following command:

```bash
docker build --force-rm --no-cache -f Dockerfile -t ${DOCKER_IMAGE} .
```

## Run DSRS Redis as a standalone container

Prior to start the application, you will need to have the PMem in fsdax mode with a file system and mounted in `/mnt/dax0`. To know how to configure, read the [documentation of DSRS](../README.md#configuration-steps)

To start the application

```bash
docker run --mount type=bind,source=/mnt/dax0,target=/mnt/pmem0 -i -d --name pmem-redis ${DOCKER_IMAGE} --nvm-maxcapacity 200 --nvm-dir /mnt/pmem0 --nvm-threshold 64 --protected-mode no
```

## Deploy DSRS Redis cluster on Kubernetes

### Kubernetes setup

As first step you need a Kubernetes cluster running on a Linux distribution supporting Persistent Memory. After setting up Kubernetes, you will need to enable it to support DCPMM suing the pmem-csi driver. To install the driver follow the instructions in the repo [README.md](https://github.com/intel/pmem-csi/blob/release-0.5/README.md) file.

### Redis operator install

The source code of the redis operator can be found in this [repository](https://github.com/spotahome/redis-operator).

To install the operator, go to you kubernetes control plane and execute the following command:

```bash
kubectl create -f https://raw.githubusercontent.com/spotahome/redis-operator/master/example/operator/all-redis-operator-resources.yaml
```

### Redis operator usage

After installing the operator you are ready to deploy redisfailover instances using a yaml file, there is an example for persistent memory [here](https://github.com/spotahome/redis-operator/blob/master/example/redisfailover/pmem.yaml). You can download it and change the source of the image to wherever DSRS Redis image is located. We have created our own yaml based on this example, you can find it in this repo with the name: `test/redis-failover.yml`

In the `test/redis-failover.yml` there is a placeholder for the image name, substitute the word `PMEM_REDIS_IMAGE` with the name of the DSRS redis image.

To start a redisfailover instance in Kubernetes using our yaml, move the file to the kubernetes server, then run:

```bash
kubectl create -f redis-failover.yml
```

#### Known issues

There is an issue of the sentinels not having enough memory to create the InitContainer. The issue has been reported [here](https://github.com/spotahome/redis-operator/issues/176). The current workaround is to build the image increasing the limits for the InitContainer memory to 32Mb

**Note**
If you already have a redis-operator, you will need to delete it before installing a new one.

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

