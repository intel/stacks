# System Stacks Deep Learning Compiler

[![](https://images.microbadger.com/badges/image/sysstacks/dlrs-ml-compiler-clearlinux.svg)](https://microbadger.com/images/sysstacks/dlrs-ml-compiler-clearlinux "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/sysstacks/dlrs-ml-compiler-clearlinux.svg)](https://microbadger.com/images/sysstacks/dlrs-ml-compiler-clearlinux "Get your own version badge on microbadger.com")

Stacks Deep Learning Compiler based on TVM on Clear Linux.


### Building Locally

Default build args in Docker are on: https://docs.docker.com/engine/reference/builder/#arg

>NOTE: This command is for locally building this image alone.

```
docker build --no-cache --build-arg clear_ver="32690" -t clearlinux/stacks-tvm .
```

To install front-end deep learning libraries, use:

```bash
./scripts/install_dl_frontends.sh
```

This will install TensorFlow, Pytorch, TorchVision and ONNX.

### Build ARGs

* `clear_ver` specifies the latest validated Clearlinux version for this DLRS Dockerfile.
>NOTE: Changing this version may result in errors, if you want to upgrade the OS version, you should use `swupd_args` instead.
