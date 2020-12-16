#!/bin/bash

set -e 

# add powertools repo
dnf -y install \
	dnf-plugins-core \
	https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
	&& dnf config-manager --set-enabled powertools


# install opa drivers
dnf install -y \
	libibverbs-devel numactl-devel \
	libibmad-devel libibumad-devel \
	librdmacm-devel ca-certificates \
	libxml2-devel libibverbs libibmad \
	numactl libibumad librdmacm \
	libpfm.i686 ibacm libpsm2 libpsm2-devel \
	libpsm2-compat opa-basic-tools opa-fastfabric \
	opa-fm opa-address-resolution rdma-core \
	perl qperf perftest elfutils-libelf-devel \
	libstdc++-devel gcc-gfortran atlas tcl papi \
	expect tcsh sysfsutils bc rpm-build redhat-rpm-config \
	kernel-devel which iproute net-tools libhfi1 \
	&& dnf clean all
