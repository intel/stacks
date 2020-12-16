#!/bin/bash

dnf install -y wget bzip2

# install libfabrics with psm2 support
wget https://github.com/ofiwg/libfabric/releases/download/v1.11.1/libfabric-1.11.1.tar.bz2 \
	&& tar xjf libfabric-1.11.1.tar.bz2 \
	&& cd libfabric-1.11.1 \
	&& ./configure --enable-psm2=yes --prefix=/usr \
	&& make && make install && cd .. \
	&& rm -rf libfabric* \
	&& echo "libfabrics installed successfully"
