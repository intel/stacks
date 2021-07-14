# Data Services Reference Stack(DSRS) – Spark

DSRS Spark is packaged as a Docker container based on Red Hat UBI and a set of scripts to build components including: 

- [Apache Spark](https://spark.apache.org/) 

- [Intel® MKL](https://software.intel.com/content/www/us/en/develop/tools/math-kernel-library.html) or [OpenBLAS](https://www.openblas.net/) depending on the image you are using.

## Source code

The latest source code and documentation related to build and deploy the image can be found here:

- [https://github.com/intel/stacks](https://github.com/intel/stacks)


## DSRS Spark Stack

DSRS Spark Stack releases two Docker images that ships Spark 3.0.2, OpenJDK11 and BLAS libraries (either MKL or OpenBLAS):

1. Red Hat UBI based image with Intel MKL library, hereafter MKL image
2. Red Hat UBI based image with OpenBLAS library, hereafter OpenBLAS image

The docker images provides development tools and frameworks including Spark optimized for Intel plattforms. You can use this environment to store and process large amounts of data, or try new ideas.

## Pull DSRS Spark images

If you want to fetch the MKL image run the command:

```bash
docker pull sysstacks/dsrs-spark-rhel:latest
```

For the OpenBLAS image run the command:

```bash
docker pull sysstacks/dsrs-spark-rhel:latest-oss
```

The difference in the name resides in the tag postfix. OpenBLAS image tag ends with `-oss` meaning "open source software", this type of naming convention is used to indicate that the image has no Intel specific software included.

For the following steps of the documentation, we will use the MKL image as reference, nevertheless it is the same for both flavor of images.

## Build DSRS Spark image

To build an MKL image by yourself, install the docker dependencies and run the following command:

```bash
docker build --force-rm --no-cache -f Dockerfile -t ${DOCKER_IMAGE} .
```

To build an OpenBLAS image, the build command is the following:

```bash
docker build --force-rm --no-cache -f oss.Dockerfile -t ${DOCKER_IMAGE} .
```



## Runninng DSRS Spark cluster on Kubernetes and OpenShift

For running a Spark cluster on Kubernetes and OpenShift, we provide a Helm chart for this purpose. To run a cluster you must know the name of the image. The name is `sysstacks/dsrs-spark-rhel:latest` for MKL-based image, and `sysstacks/dsrs-spark-rhel:latest-oss` for OpenBLAS-based image.

>>>
This Helm chart provides a basic configuration for running a Spark cluster, for advanced configuration you can manually modify the templates and values on `spark-helm/templates` and `spark-helm/values.yaml`.
>>> 


### Requisites

- An existing [Kubernetes](https://kubernetes.io/) or [OpenShift](https://www.openshift.com/) cluster
- [Helm](https://helm.sh/) already installed

### Steps to create the cluster

1. Edit `spark-helm/values.yaml` according to your deployment.
2. Run `helm install <deployment-name> ./spark-helm`

Eventually you will see the deployment running with `kubectl get pods` for Kubernetes or  `oc get pods` for OpenShift.


## Running DSRS Spark on Docker

To run a container you must know the name of the image or hash of the image. If you followed the Pull instructions aforementioned, the name is `sysstacks/dsrs-spark-rhel:latest` for MKL-based image, and `sysstacks/dsrs-spark-rhel:latest-oss` for OpenBLAS-based image. The hash can be retrieved along with all imported images with the command:

```bash
docker images
```

Now that you know the name of the image, you can run it:

```bash
docker run --ulimit nofile=1000000:1000000 --name <container name> --network host --rm -i -t sysstacks/dsrs-spark-rhel:latest bash
```

or if you need to provide volume mappings as per your machines directory paths:

```bash
docker run --ulimit nofile=1000000:1000000 --name <container name> -v /data/datad:/mnt/disk1/spark/mkl -v /data/datae:/mnt/disk2/spark/mkl --network host --rm -i -t sysstacks/dsrs-spark-rhel:latest
```

Please note that `/data/datad` and `/data/datae` are directories on the host machine while `/mnt/disk1/spark/mkl`, `/mnt/disk2/spark/mkl` are the mount points inside the container in the form of directories and are created on demand if they do not exist yet.
Also, for simplicity we provided --network as host, so host machine IP itself can be used to access container.

## Manual configuration
If you want to manually configure the analytics services inside the containers you can log in as root to an existing container in the following way:

```bash
docker exec -it -u root <container-id> bash
```

Once logged in you can modify everything on the container to fulfill your needs. Spark and Hadoop related files are under `/opt` directory.

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

