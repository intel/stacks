# Stacks Deep Learning Compiler 

[![](https://images.microbadger.com/badges/image/clearlinux/stacks-ml-compiler.svg)](https://microbadger.com/images/clearlinux/stacks-ml-compiler "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/clearlinux/stacks-ml-compiler.svg)](https://microbadger.com/images/clearlinux/stacks-ml-compiler "Get your own version badge on microbadger.com")

Stacks Deep Learning Compiler based on TVM on Clear Linux.


### Building Locally

Default build args in Docker are on: https://docs.docker.com/engine/reference/builder/#arg

>NOTE: This command is for locally building this image alone.

```
docker build --no-cache --build-arg clear_ver="31290" -t clearlinux/stacks-tvm .
```

To install front-end deep learning libraries, use:

```bash
./scripts/install_dl_frontends.sh
```

This will install TensorFlow, Pytorch, TorchVision and ONNX.

### Build ARGs

* `clear_ver` specifies the latest validated Clearlinux version for this DLRS Dockerfile.
>NOTE: Changing this version may result in errors, if you want to upgrade the OS version, you should use `swupd_args` instead.

* `swupd_args` specifies [swupd update](https://github.com/clearlinux/swupd-client/blob/master/docs/swupd.1.rst#options) flags passed to the update during build.

>NOTE: An empty `swupd_args` will default to 31290. Consider this when building as an OS upgrade won't be performed. If you'd like to upgrade the OS version, you can either do it manually inside a running container or add `swupd_args="<desired version>"` to the build command. The latest validated version is 31290, using a different one might result in unexpected errors.
