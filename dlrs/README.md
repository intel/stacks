## Deep Learning Reference Stack README


The Deep Learning Reference Stack is an integrated, highly-performant open source stack optimized for Intel® Xeon® Scalable platforms.

Highly-tuned and built for cloud native environments, the release enables developers to quickly prototype by reducing complexity associated with integrating multiple software components, while still giving users the flexibility to customize their solutions.

The stack includes highly tuned software components across the operating system (Ubuntu* or Centos*), deep learning framework (TensorFlow*, PyTorch*), deep learning libraries ([Intel® oneAPI Deep Neural Network Library (oneDNN)](https://01.org/dnnl)) and other software components. This open source community release is part of an effort to ensure AI developers have easy access to all features and functionality of Intel platforms.To offer more flexibility, there are multiple versions of the Deep Learning Reference Stack.
 
### For Ubuntu based images:
* [Tensorflow 1.15.3, Intel® MKL-DNN and Intel® AVX512-Deep Learning Boost (v0.6.1)](https://hub.docker.com/r/sysstacks/dlrs-tensorflow-ubuntu)
* [TensorFlow 2.4.0(2b8c0b1) with oneDNN primitives, Intel® MKL, Intel® DLBoost and OpenVINO™ - Deep Learning Deployment Toolkit v2020.4 (TBB)](https://hub.docker.com/r/sysstacks/dlrs-tensorflow2-ubuntu)
* [PyTorch 1.7(458ce5d) DLRS Docker image with Intel® oneAPI Deep Neural Network Library (oneDNN)](https://hub.docker.com/r/sysstacks/dlrs-pytorch-ubuntu)
* [TensorFlow Serving 2.3.0, Deep Learning model serving solution for TensorFlow models](https://hub.docker.com/repository/docker/sysstacks/dlrs-serving-ubuntu)
 
### For Centos based images:
* [Tensorflow 1.15.3, Intel® MKL-DNN and Intel® AVX512-Deep Learning Boost (v0.6.1)](https://hub.docker.com/r/sysstacks/dlrs-tensorflow-centos)
* [TensorFlow 2.3.0 with oneDNN primitives, Intel® MKL, Intel® DLBoost and OpenVINO™ - Deep Learning Deployment Toolkit v2020.4 (TBB)](https://hub.docker.com/r/sysstacks/dlrs-tensorflow2-centos)
* [PyTorch 1.7(458ce5d) DLRS Docker image with Intel® oneAPI Deep Neural Network Library (oneDNN)](https://hub.docker.com/r/sysstacks/dlrs-pytorch-centos)
 
Please see the tags tab in dockerhub to find the versions listed above, valid tags for version 0.7 of DLRS are `latest` (default), `v0.7.0`.
