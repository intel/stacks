# Deep Learning Reference Stack with Tensorflow and Intel® oneAPI Deep Neural Network Library (oneDNN)

### Building Locally

We have created a set of Dockerfiles that allow you to build DLRS Tensorflow with different configurations. You will be able to pick the OS (Ubuntu or Centos), then pick the flavour, either `core`, which is a leaner image with just the framework, and `full` which includes the framework and extra features. Please refer to the table below to see all features and configurations.

|      | Framework | Features |
|------|-----------|----------|
| Core | X         |          |
| Full | X         | X        |
|      |           |          |

Framework:

* TensorFlow* 1.15.3 or
* TensorFlow* 2.4.0(2b8c0b1)

Features:

* Transformers
* Horovod 0.20.0
* OpenVINO™ model server version 2021.1
* Seldon core 1.2.0

> NOTE: We recommend you enable [Docker Buildkit](https://docs.docker.com/develop/develop-images/build_enhancements/) to have concurrent dependency resolution and automatic garbage collection. Docker Buildkit has been integrated in Docker since 18.06, if you have an older version, please ignore this note.

#### Enable Docker Buildkit (see note above)

```bash
export DOCKER_BUILDKIT=1
```

### Building Ubuntu based DLRS

Tensorflow 1.15.0

Core:

```
docker build --build_arg tf_ver=tf1 -t dlrs-tensorflow-ubuntu:v0.8.0 -f Dockerfile.ubuntu --target tf_core .
```

Full:

```
docker build --build_arg tf_ver=tf1 -t dlrs-tensorflow-ubuntu:v0.8.0 -f Dockerfile.ubuntu --target tf_full.
```

Tensorflow 2.4.0 (2b8c0b1)

Core:

```
docker build --build_arg tf_ver=tf2 -t dlrs-tensorflow2-ubuntu:v0.8.0 -f Dockerfile.ubuntu --target tf_core .
```

Full:

```
docker build --build_arg tf_ver=tf2 -t dlrs-tensorflow2-ubuntu:v0.8.0 -f Dockerfile.ubuntu --target tf_full.
```

### Building Centos based DLRS

Tensorflow 1.15.0

Core:

```
docker build --build_arg tf_ver=tf1 -t dlrs-tensorflow-centos:v0.8.0 -f Dockerfile.centos --target tf_core .
```

Full:

```
docker build --build_arg tf_ver=tf1 -t dlrs-tensorflow-centos:v0.8.0 -f Dockerfile.centos --target tf_full.
```

Tensorflow 2.4.0 (2b8c0b1)

Core:

```
docker build --build_arg tf_ver=tf2 -t dlrs-tensorflow2-centos:v0.8.0 -f Dockerfile.centos --target tf_core .
```

Full:

```
docker build --build_arg tf_ver=tf2 -t dlrs-tensorflow2-centos:v0.8.0 -f Dockerfile.centos --target tf_full.
```
