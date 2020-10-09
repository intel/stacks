#---------------------------------------------------------------------
# Base instance to build MKL based images on Clear Linux
#---------------------------------------------------------------------
ARG clear_ver
FROM clearlinux/stacks-clearlinux:$clear_ver as base
LABEL maintainer=otc-swstacks@intel.com

# update os and add required bundles
RUN swupd bundle-add git curl wget \
    java-basic sysadmin-basic package-utils \
    devpkg-zlib go-basic devpkg-tbb

# fix for stdlib not found issue
RUN ln -sf /usr/lib64/libstdc++.so /usr/lib64/libstdc++.so.6

COPY ./scripts/ /scripts

RUN go get github.com/bazelbuild/bazelisk \
    && export PATH=$PATH:/go/bin/ \
    && ln -s /go/bin/bazelisk /usr/bin/bazel
