#!/bin/bash
# Script for building spark with openblas support
set -xe

SPARK_VERSION=$1
HADOOP_COMPATIBILITY_VERSION='3.2.0'

export JAVA_HOME="/usr/lib/jvm/java-11-openjdk"

# Allow maven to use more memory
export MAVEN_OPTS="$MVN_OPTS -Xmx2g -XX:ReservedCodeCacheSize=1g"

# Environment variables
INITIAL_DIR=$(pwd)
SPARK_BUILD_DIR='/tmp/spark-build'
SPARK_URL="https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION.tgz"
SPARK_TAR_FILE="spark-$SPARK_VERSION.tgz"
SPARK_SRC_DIR="$SPARK_BUILD_DIR/spark-$SPARK_VERSION"
SPARK_GPG_KEYS="https://downloads.apache.org/spark/KEYS"
SPARK_GPG_KEYS_FILE='KEYS'
SPARK_SIGNATURE="https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION.tgz.asc"
SPARK_SIGNATURE_FILE="spark-$SPARK_VERSION.tgz.asc"
SPARK_CHECKSUM="https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION.tgz.sha512"
SPARK_CHECKSUM_FILE="spark-$SPARK_VERSION.tgz.sha512"
SPARK_VERIFICATION_FILE='gpg-verify.txt'


if [ -d $SPARK_BUILD_DIR ]
then
        rm -rf $SPARK_BUILD_DIR/*
else
        mkdir $SPARK_BUILD_DIR
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


cd $SPARK_BUILD_DIR
curl -LO $SPARK_URL
curl -LO $SPARK_GPG_KEYS
curl -LO $SPARK_SIGNATURE
curl -LO $SPARK_CHECKSUM


# Verify source code
gpg --import $SPARK_GPG_KEYS_FILE
gpg --verify $SPARK_SIGNATURE_FILE $SPARK_TAR_FILE 2> $SPARK_BUILD_DIR/$SPARK_VERIFICATION_FILE
GPG_VERIFICATION=$(cat $SPARK_BUILD_DIR/$SPARK_VERIFICATION_FILE | grep -i 'Good signature' | wc -l)
if [ "$GPG_VERIFICATION" -eq 1  ]; then
	echo "GPG verification successful"
else
	echo "GPG verification failed"
	cd $INITIAL_DIR
	exit 1
fi
SPARK_PROCESSED_CHECKSUM=$(cat $SPARK_BUILD_DIR/$SPARK_CHECKSUM_FILE | sed 's/spark-3.0.0.tgz://g' | sed 's/\ //g' | tr -d '\n')
CHECKSUM_VERIFICATION=$(sha512sum $SPARK_BUILD_DIR/$SPARK_TAR_FILE | grep -i "$SPARK_PROCESSED_CHECKSUM" |  wc -l )
if [ "$CHECKSUM_VERIFICATION" == "1"  ]; then
        echo "Checksum verification successful"
else
        echo "Checksum verification failed"
        cd $INITIAL_DIR
        exit 1
fi


# Start building spark
cd $SPARK_BUILD_DIR
tar xzf $SPARK_BUILD_DIR/$SPARK_TAR_FILE
cd $SPARK_SRC_DIR
./build/mvn -Pyarn -Dhadoop.version=$HADOOP_COMPATIBILITY_VERSION -Pkubernetes -DskipTests -Pnetlib-lgpl clean package

cd $INITIAL_DIR

