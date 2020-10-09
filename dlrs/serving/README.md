# Deep Learning Reference Stack with Tensorflow Serving and OpenVINO Model Server

### Building Locally

We have created a Dockerfile that allows you to build DLRS Servings.

Features:

* TensorFlow Serving 2.3.0, Deep Learning model serving solution for TensorFlow models.
* OpenVINO™ model server version 2020.4, delivering improved neural network performance on Intel processors, helping unlock cost-effective, real-time vision applications.

> NOTE: We recommend you enable [Docker Buildkit](https://docs.docker.com/develop/develop-images/build_enhancements/) to have concurrent dependency resolution and automatic garbage collection. Docker Buildkit has been integrated in Docker since 18.06, if you have an older version, please ignore this note.

#### Enable Docker Buildkit (see note above)

```bash
export DOCKER_BUILDKIT=1
```

```
docker build -t dlrs-serving-ubuntu:v0.7.0 -f Dockerfile .
```
