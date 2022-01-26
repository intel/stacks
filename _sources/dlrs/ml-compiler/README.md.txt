## Stacks Deep Learning Compiler 

Early release of stacks deep learning compiler based on TVM for System Stacks

Tensor Virtual Machine or TVM compiler image is a layered deep learning graph 
compiler that is optimized for CPUs and have runtime bindings for Python.

Front end libraries can interface with the compiler, loading pretrained models,
to be compiled and deployed using TVM. There are 2 levels of optimizing phases
in TVM, the first one is when a model is loaded, where graph level optimizations
such as layer fusion and layout transformation are attempted. The next phase
includes operator level optimization and code generation including a specialized operator
generation using an intelligent scheduler, please refer to the [paper](https://arxiv.org/pdf/1802.04799.pdf)
for more details.

### Frontends

To install front-end deep learning libraries, use:

```bash
./scripts/install_dl_frontends.sh
```

This will install Pytorch, TorchVision and ONNX.

### Smoke tests

Run some core unit and functional tests:

```bash
cd ./tvm/tests
docker run -it -v`pwd`:/workspace dlrs-ml-compiler
./workspace/run_tests.sh
```

