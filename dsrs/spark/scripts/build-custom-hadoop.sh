#!/bin/bash
# Script for building custom Hadoop installation
set -xe

HADOOP_VERSION='3.2.0'

export JAVA_HOME="/usr/lib/jvm/java-11-openjdk"

# Allow maven to use more memory
export MAVEN_OPTS="$MVN_OPTS -Xmx2g -XX:ReservedCodeCacheSize=1g"

# Environment variables
INITIAL_DIR=$(pwd)
HADOOP_BUILD_DIR='/tmp/hadoop-build'
HADOOP_URL="https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION-src.tar.gz"
HADOOP_TAR_FILE="hadoop-$HADOOP_VERSION-src.tar.gz"
HADOOP_SRC_DIR="$HADOOP_BUILD_DIR/hadoop-$HADOOP_VERSION-src"
HADOOP_GPG_KEYS='https://downloads.apache.org/hadoop/common/KEYS'
HADOOP_GPG_KEYS_FILE='KEYS'
HADOOP_SIGNATURE="https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION-src.tar.gz.asc"
HADOOP_SIGNATURE_FILE="hadoop-$HADOOP_VERSION-src.tar.gz.asc"
HADOOP_CHECKSUM="https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION-src.tar.gz.mds"
HADOOP_CHECKSUM_FILE="hadoop-$HADOOP_VERSION-src.tar.gz.sha512"
HADOOP_VERIFICATION_FILE='gpg-verify.txt'
HADOOP_PATCHES_DIR="/tmp/patches/hadoop"

if [ -d $HADOOP_BUILD_DIR ]
then
	if [ -f  /usr/bin/sudo ]; then
		sudo rm -rf $HADOOP_BUILD_DIR/*
	else
                rm -rf $HADOOP_BUILD_DIR/*
	fi
else
        mkdir $HADOOP_BUILD_DIR
fi


if [ -z ${http_proxy+x} ]; then
	echo "No http_proxy variable is set";
else
	echo "http_proxy: $http_proxy";
	HTTP_PROXY_HOST=$(echo $http_proxy | sed -e 's!http[s]\?://!!g' | awk -F  ":" '{print $1}')
	HTTP_PROXY_PORT=$(echo $http_proxy | sed -e 's!http[s]\?://!!g' | awk -F  ":" '{print $2}' | sed -e 's!/!!g' )
	export MVN_OPTS="$MVN_OPTS -Dhttp.proxyHost=$HTTP_PROXY_HOST -Dhttp.proxyPort=$HTTP_PROXY_PORT"
	export MAVEN_OPTS="$MVN_OPTS"
fi

if [ -z ${https_proxy+x} ]; then
	echo "No https_proxy variable is set";
else
	echo "https_proxy: $https_proxy";
        HTTPS_PROXY_HOST=$(echo $https_proxy | sed -e 's!http[s]\?://!!g' | awk -F  ":" '{print $1}')
        HTTPS_PROXY_PORT=$(echo $https_proxy | sed -e 's!http[s]\?://!!g' | awk -F  ":" '{print $2}' | sed -e 's!/!!g' )
	export MVN_OPTS="$MVN_OPTS -Dhttps.proxyHost=$HTTPS_PROXY_HOST -Dhttps.proxyPort=$HTTPS_PROXY_PORT"
	export MAVEN_OPTS="$MVN_OPTS"
fi

cd $HADOOP_BUILD_DIR
curl -LO $HADOOP_URL
curl -LO $HADOOP_GPG_KEYS
curl -LO $HADOOP_SIGNATURE
curl -LO $HADOOP_CHECKSUM


# Verify source code
gpg --import $HADOOP_GPG_KEYS_FILE
gpg --verify $HADOOP_SIGNATURE_FILE $HADOOP_TAR_FILE 2> $HADOOP_BUILD_DIR/$HADOOP_VERIFICATION_FILE
GPG_VERIFICATION=$(cat $HADOOP_BUILD_DIR/$HADOOP_VERIFICATION_FILE | grep -i 'Good signature' | wc -l)
if [ "$GPG_VERIFICATION" -eq 1  ]; then
        echo "GPG verification successful"
else
        echo "GPG verification failed"
        cd $INITIAL_DIR
        exit 1
fi
HADOOP_PROCESSED_CHECKSUM=$(cat $HADOOP_BUILD_DIR/$HADOOP_CHECKSUM_FILE | tail -2 | sed 's/hadoop-3.3.0-src.tar.gz://g' | sed 's/\ //g' | tr -d '\n' | awk -F= '{print $2}' )
CHECKSUM_VERIFICATION=$(sha512sum $HADOOP_BUILD_DIR/$HADOOP_TAR_FILE | grep -i "$HADOOP_PROCESSED_CHECKSUM" |  wc -l )
if [ "$CHECKSUM_VERIFICATION" == "1"  ]; then
        echo "Checksum verification successful"
else
        echo "Checksum verification failed"
        cd $INITIAL_DIR
        exit 1
fi


# Start Hadoop build
tar xzf $HADOOP_TAR_FILE
cd $HADOOP_SRC_DIR

# Install Intel ISA-L
git clone https://github.com/intel/isa-l 
cd isa-l/ 
./autogen.sh 
./configure 
make -j$(nproc) 
if [ -f /usr/bin/sudo ]; then
	sudo make install
else
	make install
fi

curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protobuf-all-3.6.1.tar.gz 
tar xzf protobuf-all-3.6.1.tar.gz 
cd protobuf-3.6.1 
./configure 
make -j$(nproc) 
if [ -f /usr/bin/sudo ]; then
        sudo make install
	sudo ldconfig
else
        make install
	ldconfig
fi

curl -LO https://github.com/Kitware/CMake/releases/download/v3.15.2/cmake-3.15.2.tar.gz 
tar -zxvf cmake-3.15.2.tar.gz 
cd cmake-3.15.2 
./bootstrap 
make -j$(nproc) 
if [ -f /usr/bin/sudo ]; then
        sudo make install
else
        make install
fi


cd $HADOOP_SRC_DIR
patch -p1 < $HADOOP_PATCHES_DIR/0001-Integrate-JDK11.patch 
patch -p1 < $HADOOP_PATCHES_DIR/HADOOP-11364.01.patch
patch -p1 < $HADOOP_PATCHES_DIR/0001-Change-protobuf-version.patch 
patch -p1 < $HADOOP_PATCHES_DIR/protobuf3.patch 
patch -p1 < $HADOOP_PATCHES_DIR/protobuf-3.6.1-hadoop-3.2.0-On-CLR.patch 
patch -p1 < $HADOOP_PATCHES_DIR/0001-YARN-8498.-Yarn-NodeManager-OOM-Listener-Fails-Compi.patch

mvn package -Pdist -DskipTests -Dmaven.javadoc.skip=true -Djavac.version=11 -Dmaven.plugin-tools.version=3.6.0
