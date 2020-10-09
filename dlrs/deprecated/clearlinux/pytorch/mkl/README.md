# Deep Learning Reference Stack with Pytorch and Intel® oneAPI Deep Neural Network Library (oneDNN)

[![](https://images.microbadger.com/badges/image/sysstacks/dlrs-pytorch-clearlinux:v0.6.0.svg)](https://microbadger.com/images/sysstacks/dlrs-pytorch-clearlinux:v0.6.0 "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/sysstacks/dlrs-pytorch-clearlinux:v0.6.0.svg)](https://microbadger.com/images/sysstacks/dlrs-pytorch-clearlinux:v0.6.0 "Get your own version badge on microbadger.com")

### Building Locally

Default build args in Docker are on: https://docs.docker.com/engine/reference/builder/#arg

>NOTE: This command is for locally building this image alone.

```
docker build --no-cache --build-arg clear_ver="32690" -t clearlinux/stacks-pytorch-mkl .
```

### Build ARGs

* `clear_ver` specifies the latest validated Clearlinux version for this DLRS Dockerfile.
>NOTE: Changing this version may result in errors, if you want to upgrade the OS version, you should use `swupd_args` instead.
