#!/bin/bash
# Script for building cassandra with pmem support 
#All the repositories are built on CASSANDRA_BUILD_DIR and a tar.gz file is generated
#on the folder you run this script
set -x

if [ -d '/usr/lib/jvm/java-1.8.0-openjdk' ]; then
	# CentOS and Clear Linux location
        export JAVA_HOME='/usr/lib/jvm/java-1.8.0-openjdk'
else
	# Ubuntu location
        export JAVA_HOME='/usr/lib/jvm/java-1.8.0-openjdk-amd64'
fi

if [ -z ${http_proxy+x} ]; then 
	echo "No http_proxy variable is set"; 
else 
	echo "http_proxy: $http_proxy"; 
	HTTP_PROXY_HOST=$(echo $http_proxy | sed -e 's!http[s]\?://!!g' | awk -F  ":" '{print $1}')
	HTTP_PROXY_PORT=$(echo $http_proxy | sed -e 's!http[s]\?://!!g' | awk -F  ":" '{print $2}' | sed -e 's!/!!g' )
	export MVN_OPTS="$MVN_OPTS -Dhttp.proxyHost=$HTTP_PROXY_HOST -Dhttp.proxyPort=$HTTP_PROXY_PORT"
	export ANT_OPTS="$ANT_OPTS -Dhttp.proxyHost=$HTTP_PROXY_HOST -Dhttp.proxyPort=$HTTP_PROXY_PORT"
fi

if [ -z ${https_proxy+x} ]; then
	echo "No https_proxy variable is set";
else
	echo "https_proxy: $https_proxy";
        HTTPS_PROXY_HOST=$(echo $https_proxy | sed -e 's!http[s]\?://!!g' | awk -F  ":" '{print $1}')
        HTTPS_PROXY_PORT=$(echo $https_proxy | sed -e 's!http[s]\?://!!g' | awk -F  ":" '{print $2}' | sed -e 's!/!!g' )
	export MVN_OPTS="$MVN_OPTS -Dhttps.proxyHost=$HTTPS_PROXY_HOST -Dhttps.proxyPort=$HTTPS_PROXY_PORT"
        export ANT_OPTS="$ANT_OPTS -Dhttps.proxyHost=$HTTPS_PROXY_HOST -Dhttps.proxyPort=$HTTPS_PROXY_PORT"
fi



INITIAL_DIR=$(pwd)
CASSANDRA_BUILD_DIR='/tmp/cassandra-build'
LLPL_REPO='https://github.com/pmem/llpl.git'
LLPL_BASELINE_COMMIT='d5f3ad7'
CASSANDRA_PMEM_REPO='https://github.com/intel/cassandra-pmem'
CASSANDRA_PMEM_BRANCH='13981_llpl_engine'
CASSANDRA_PMEM_BASELINE_COMMIT='b99b63d'

if [ -d $CASSANDRA_BUILD_DIR ] 
then
	rm -rf $CASSANDRA_BUILD_DIR/*
else
	mkdir $CASSANDRA_BUILD_DIR
fi

#Build LLPL
cd $CASSANDRA_BUILD_DIR
git clone $LLPL_REPO && \
cd $CASSANDRA_BUILD_DIR/llpl && \
echo -e "Switching to baseline commit for llpl $LLPL_BASELINE_COMMIT\n" && \
git checkout $LLPL_BASELINE_COMMIT &> /dev/null && \
git log -1 && \
make && \
cd $CASSANDRA_BUILD_DIR/llpl/target/classes && \
jar cvf llpl.jar lib/


#Build Cassandra PMEM
cd $CASSANDRA_BUILD_DIR && \
git clone -b $CASSANDRA_PMEM_BRANCH --single-branch  $CASSANDRA_PMEM_REPO && \
cd $CASSANDRA_BUILD_DIR/cassandra-pmem && \
echo -e "Switching to baseline commit for cassandra-pmem $CASSANDRA_PMEM_BASELINE_COMMIT\n" && \
git checkout $CASSANDRA_PMEM_BASELINE_COMMIT &> /dev/null && \
git log -1 && \
cp $CASSANDRA_BUILD_DIR/llpl/target/classes/llpl.jar $CASSANDRA_BUILD_DIR/cassandra-pmem/lib/ && \
cp $CASSANDRA_BUILD_DIR/llpl/target/cppbuild/libllpl.so $CASSANDRA_BUILD_DIR/cassandra-pmem/lib/sigar-bin/ && \
ant -autoproxy _main-jar && \
ant -autoproxy stress-build && \
ant -autoproxy fqltool-build && \
cd $CASSANDRA_BUILD_DIR && \
mv cassandra-pmem cassandra
echo "Compressing build into a tar.gz file..."
tar -zcf cassandra-pmem-build.tar.gz cassandra
mv cassandra-pmem-build.tar.gz $INITIAL_DIR
cd $INITIAL_DIR

