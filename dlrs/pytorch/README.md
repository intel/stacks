# Deep Learning Reference Stack with Pytorch and Intel® oneAPI Deep Neural Network Library (oneDNN)

### Building Locally

We have created a set of Dockerfiles that allow you to build DLRS Pytorch with different configurations. You will be able to pick the OS (Ubuntu or Centos), then pick the flavour, either `core`, which is a leaner image with just the framework, and `full` which includes the framework and extra features. Please refer to the table below to see all features and configurations.

|      | Framework | Features |
|------|-----------|----------|
| Core | X         |          |
| Full | X         | X        |
|      |           |          |

Framework:

* PyTorch* 1.8
* Torchvision 

Features:

* Transformers
* Flair*
* Horovod 
* Seldon core 
* Pytorch lightning 

> NOTE: We recommend you enable [Docker Buildkit](https://docs.docker.com/develop/develop-images/build_enhancements/) to have concurrent dependency resolution and automatic garbage collection. Docker Buildkit has been integrated in Docker since 18.06, if you have an older version, please ignore this note.

#### Enable Docker Buildkit (see note above)

```bash
export DOCKER_BUILDKIT=1
```

#### Building Ubuntu based DLRS

Core:

```
docker build -t dlrs-pytorch-ubuntu:v0.9.0 -f Dockerfile.ubuntu --target ubuntu-core .
```
Full:

```
docker build -t dlrs-pytorch-ubuntu:v0.9.0 -f Dockerfile.ubuntu --target ubuntu-full .
```

#### Building Centos based DLRS

Core:

```
docker build -t dlrs-pytorch-centos:v0.9.0 -f Dockerfile.centos --target core-core .
```
Full:

```
docker build -t dlrs-pytorch-centos:v0.9.0 -f Dockerfile.centos --target centos-full .
```
