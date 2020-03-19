# Memcached DBRS

"Free & open source, high-performance, distributed memory object caching system" (https://memcached.org/). Stack ready to use DCPMM in fsdax mode for storage.

The source code used for this application can be found in the [Memcached repository](https://memcached.org/). Be sure to checkout at least v1.5.18.

## Build DBRS Memcached image

To build an image by yourself, install the docker dependencies and run the following command:

```bash
docker build --force-rm --no-cache -f Dockerfile -t ${DOCKER_IMAGE} .
```

## Run DBRS Memcached as a standalone container

Prior to start the application, you will need to have the DCPMM in fsdax mode with a file system and mounted in `/mnt/dax0`. To know how to configure, read the [documentation of DBRS](../README.md#configuration-steps)

To start the application

```bash
docker run --mount type=bind,source=/mnt/dax0,target=/mnt/pmem0 -i -d --name pmem-memcached ${DOCKER_IMAGE} -e /mnt/pmem0/memcached.file -m 64 -c 1024 -p 11211
```

where:

* '-m' max memory limit to use in megabytes.

* '-e' mmap path for external memory (DCPMM storage), for this container DCPMM should be mounted inside the container on /mnt/pmem0

* '-c' number of concurrent connections

* '-p' is the listening TCP connection port.

For more information please visit: https://memcached.org/blog/persistent-memory/

