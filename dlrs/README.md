## Deep Learning Reference Stack README


The Deep Learning Reference Stack is an integrated, highly-performant open source stack optimized for Intel® Xeon® Scalable platforms.

<img src="https://clearlinux.org/sites/default/files/single_2.png" width="400" height="300" />

Highly-tuned and built for cloud native environments, the release enables developers to quickly prototype by reducing complexity associated with integrating multiple software components, while still giving users the flexibility to customize their solutions.

The stack includes highly tuned software components across the operating system (Clear Linux OS), deep learning framework (TensorFlow*, PyTorch*), deep learning libraries ([Intel® oneAPI Deep Neural Network Library (oneDNN)](https://01.org/dnnl)) and other software components.
This open source community release is part of an effort to ensure AI developers have easy access to all features and functionality of Intel platforms.To offer more flexibility, there are multiple versions of the Deep Learning Reference Stack:

* [Tensorflow 1.15 with Intel® oneAPI Deep Neural Network Library (oneDNN)  primitives, AVX-512 Deep Learning Boost and OpenVINO™ - Deep Learning Deployment Toolkit v2020.1 (OMP)](https://hub.docker.com/r/sysstacks/dlrs-tensorflow-clearlinux)
* [Tensorflow 2.2.0 with Intel® oneAPI Deep Neural Network Library (oneDNN) primitives, AVX-512 Deep Learning Boost and OpenVINO™ - Deep Learning Deployment Toolkit v2020.1 (TBB)]( https://hub.docker.com/r/sysstacks/dlrs-tensorflow2-clearlinux)
* [TensorFlow 1.15 with Eigen optimized for Intel Architecture](https://hub.docker.com/r/sysstacks/dlrs-tensorflow-clearlinux)
* [PyTorch 1.14 DLRS Docker image with Intel® oneAPI Deep Neural Network Library (oneDNN)](https://hub.docker.com/r/sysstacks/dlrs-pytorch-clearlinux)
* [PyTorch 1.14 DLRS Docker image with Eigen and OpenBLAS](https://hub.docker.com/r/sysstacks/dlrs-pytorch-clearlinux)
* [Deep Learning Compiler with TVM and Intel® Math Kernel Library](https://hub.docker.com/r/sysstacks/dlrs-ml-compiler-clearlinux)



Please see the tags tab in dockerhub to find the versions listed above, valid tags for version 6 of DLRS are `latest` (default), `v0.6.0` and for the eigen versions `v0.6.0-oss`
