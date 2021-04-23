## Deep Learning Reference Stack


The Deep Learning Reference Stack is an integrated, highly-performant open source stack optimized for Intel® Xeon® Scalable platforms.


<img src="https://intel.github.io/stacks/_images/dlrs_single_2.png" />

Highly-tuned and built for cloud native environments, the release of DLRS enables developers to quickly prototype by reducing complexity associated with integrating multiple software components, while still giving users the flexibility to customize their solutions.

The stack includes highly tuned software components across the operating system (Ubuntu* or Centos*), deep learning framework (TensorFlow*, PyTorch*), deep learning libraries ([Intel® oneAPI Deep Neural Network Library (oneDNN)](https://01.org/dnnl)) and other software components. This open source community release is part of an effort to ensure AI developers have easy access to all features and functionality of Intel platforms.To offer more flexibility, there are multiple versions of the Deep Learning Reference Stack.
 
### For Ubuntu based images:

* [TensorFlow 1.15.3 with Intel® oneDNN primitives, Intel® AVX512-Deep Learning Boost and OpenVINO™ - DLDT v2020.3 (TBB)](https://hub.docker.com/r/sysstacks/dlrs-tensorflow-ubuntu)
* [TensorFlow 2.4.0 with Intel® oneDNN primitives, Intel® DL Boost and OpenVINO™ - DLDT v2020.3 (TBB)](https://hub.docker.com/r/sysstacks/dlrs-tensorflow2-ubuntu)
* [PyTorch 1.8 with with oneDNN primitives, Intel® DL Boost](https://hub.docker.com/r/sysstacks/dlrs-pytorch-ubuntu)
* [TensorFlow Serving 2.3.0 and OpenVINO™ v2020.4 GPU accelerated serving solution for Deep Learning models](https://hub.docker.com/repository/docker/sysstacks/dlrs-serving-ubuntu)
* [Tensor Virtual Machine or TVM Deep Learning Compiler Image with oneDNN primitives](https://hub.docker.com/r/sysstacks/dlrs-ml-compiler-ubuntu)
 
### For Centos based images:

* [TensorFlow 1.15.3 with Intel® oneDNN primitives, Intel® DL Boost and OpenVINO™ - DLDT v2020.3 (TBB)](https://hub.docker.com/r/sysstacks/dlrs-tensorflow-centos)
* [TensorFlow 2.4.0 with Intel® oneDNN primitives, Intel® DL Boost and OpenVINO™ - DLDT v2020.3 (TBB)](https://hub.docker.com/r/sysstacks/dlrs-tensorflow2-centos)
* [PyTorch 1.8 with oneDNN primitives, Intel® DL Boost](https://hub.docker.com/r/sysstacks/dlrs-pytorch-centos)
 
Please see the tags tab in dockerhub to find the versions listed above, valid tags for version 0.8 of DLRS are `latest` (default), `v0.9.0`.

### Sources

Source code for packages that are part of the solution can be found in the image: https://hub.docker.com/r/sysstacks/dlrs-sources


