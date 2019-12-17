## Deep Learning Reference Stack with TensorFlow and Intel® MKL-DNN

[![](https://images.microbadger.com/badges/image/clearlinux/stacks-dlrs-mkl.svg)](https://microbadger.com/images/clearlinux/stacks-dlrs-mkl "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/clearlinux/stacks-dlrs-mkl.svg)](https://microbadger.com/images/clearlinux/stacks-dlrs-mkl "Get your own version badge on microbadger.com")

### Building Locally

Default build args in Docker are on: https://docs.docker.com/engine/reference/builder/#arg

This directory contains a set of Dockerfiles that serve as "builders". Each of them build a certain component of the stack and are used inside Dockerfile.dlrs, which is the Dockerfile that actually builds `stacks-dlrs-mkl`. Please note all of these Dockerfiles are necessary to build the full stack. 

To loccally build stacks-dlrs-mkl, run the following:

```
make
```

The above command will create four "builder" images and a `stacks-dlrs-mkl` one, please use the latter.

### Build ARGs

* `clear_ver` specifies the latest validated Clearlinux version for this DLRS Dockerfile.
>NOTE: Changing this version may result in errors, if you want to upgrade the OS version, you should use `swupd_args` instead.

* `swupd_args` specifies [swupd update](https://github.com/clearlinux/swupd-client/blob/master/docs/swupd.1.rst#options) flags passed to the update during build.

>NOTE: An empty `swupd_args` will default to 31290. Consider this when building as an OS upgrade won't be performed. If you'd like to upgrade the OS version, you can either do it manually inside a running container or add `swupd_args="<desired version>"` to the build command. The latest validated version is 31290, using a different one might result in unexpected errors.
