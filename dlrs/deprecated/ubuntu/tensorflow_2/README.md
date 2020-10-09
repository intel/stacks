## Deep Learning Reference Stack with TensorFlow and Intel® MKL-DNN


### Building Locally

Default build args in Docker are on: https://docs.docker.com/engine/reference/builder/#arg

>NOTE: This command is for locally building this image alone.

```
docker build --no-cache --build-arg ubuntu_ver="20.04" -t dlrs-tensorflow2-ubuntu:v0.6.1 .
```
