# Media Reference Stack
[![](https://images.microbadger.com/badges/image/clearlinux/stacks-mers.svg)](https://microbadger.com/images/clearlinux/stacks-mers
"Get your own image badge on microbadger.com")

## Building Locally

The Dockerfiles for all Intel System Stacks container images are available at
[stacks repository](https://github.com/intel/stacks). These can be used to
build and modify the media image

```bash
docker build --no-cache -t clearlinux/stacks-mers .
```

> **Note:**
     Default build args in Docker are on: https://docs.docker.com/engine/reference/builder/#arg

## Pulling from Docker Hub

In case you want to pull the image directly instead of building it, official
images are located at docker hub so it can be pulled with the following command

```bash
docker pull clearlinux/stacks-mers
```

> **Note:**
     The pulled image Clear Linux version may differ from and image built
     locally and the reason is that the OS is a rolling distro. Most
     probably, the local built image will have a greater version that the one
     pulled from Docker hub, the former not tested for the particular OS version.

## Running the Media Container

Once you have the Media Reference Stack image, run it with 

```bash
docker run -it clearlinux/stacks-mers
```

> **Note:**
    Since Clear Linux OS is a stateless system, avoid modifying the
    files under the `/usr` directory instead use `/etc` otherwise the software
    updater may overwrite `/usr` files.

## Run examples

For transcoding and video analytics examples and pipelines, please see the
official documentation at: https://clearlinux.org/sw/stacks/media-reference
