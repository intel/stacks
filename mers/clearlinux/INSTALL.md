# Media Reference Stack
[![](https://images.microbadger.com/badges/image/sysstacks/mers-clearlinux.svg)](https://microbadger.com/images/sysstacks/mers-clearlinux "Get your own image badge on microbadger.com")

## Building Locally

The Dockerfiles for all Intel System Stacks container images are available at
[stacks repository](https://github.com/intel/stacks). These can be used to
build and modify the media image at [MeRS](https://github.com/intel/stacks/tree/master/mers/clearlinux)

```bash
docker build --no-cache -t sysstacks/stacks-mers-clearlinux .
```

> **Note:**
     Default build args in Docker are on: https://docs.docker.com/engine/reference/builder/#arg

## Pulling from Docker Hub

In case you want to pull the image directly instead of building it, official
images are located at docker hub so it can be pulled with the following command

```bash
docker pull sysstacks/stacks-mers-clearlinux
```

> **Note:**
     The pulled image Clear Linux version may differ from and image built
     locally and the reason is that the OS is a rolling distro. Most
     probably, the local built image will have a greater version that the one
     pulled from Docker hub, the former not tested for the particular OS version.

## Running the Media Container

Once you have the Media Reference Stack image, run it with

```bash
docker run -it sysstacks/stacks-mers-clearlinux
```

> **Note:**
    Since Clear Linux OS is a stateless system, avoid modifying the
    files under the `/usr` directory instead use `/etc` otherwise the software
    updater may overwrite `/usr` files.

## Run examples

For transcoding and video analytics examples and pipelines, please see the
official documentation at: https://docs.01.org/clearlinux/latest/guides/stacks/mers.html#using-the-mers-container-image
