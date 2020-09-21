#!/bin/bash
#Script for retrieving the java upstream packages, it perfoms the following steps:
#  - The script retrieves java packages from upstream and places them on TOOLCHAIN_UPSTREAM_FILES_DIR
#  - The checksums, when available, are verified
#  - The packages are extracted on JAVA_TOOLCHAIN_DIR
#  - The enviroment variable PATH is updated using ANT_BIN_DIR and MVN_BIN_DIR
#
#  The options are:
#  -a: ant version
#  -m: maven version
#
# example:
#          get-java-tools.sh -a 1.10.7 -m 3.6.2
#

while getopts a:m: OPT
do
        case "$OPT" in
                a)
                        echo "ANT version: $OPTARG";
			ANT_VERSION=$OPTARG
                        ;;
                m)
                        echo "Maven version: $OPTARG";
			MVN_VERSION=$OPTARG
                        ;;
                *)
                        echo "No versions for packages provided";
			exit 1
                        ;;
        esac
done


WORKING_DIR=$(pwd)
JAVA_TOOLCHAIN_DIR=$WORKING_DIR/stacks-java-toolchain
TOOLCHAIN_UPSTREAM_FILES_DIR=$JAVA_TOOLCHAIN_DIR/upstream-files

# ANT URLs and dirs
#ANT_VERSION=1.10.7
ANT_TAR=apache-ant-$ANT_VERSION-bin.tar.gz
ANT_CHECKSUM=apache-ant-$ANT_VERSION-bin.tar.gz.sha512
ANT_URL=http://mirror.cc.columbia.edu/pub/software/apache//ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz
ANT_CHECKSUM_URL=https://www.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz.sha512
ANT_SIGNATURE_URL=https://www.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz.asc
ANT_BIN_DIR=$JAVA_TOOLCHAIN_DIR/apache-ant-$ANT_VERSION/bin

# Maven URLs and dirs
#MVN_VERSION=3.6.2
MVN_TAR=apache-maven-$MVN_VERSION-bin.tar.gz
MVN_CHECKSUM=apache-maven-$MVN_VERSION-bin.tar.gz.sha512
MVN_URL=http://mirrors.ibiblio.org/apache/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz
MVN_CHECKSUM_URL=https://www.apache.org/dist/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz.sha512
MVN_SIGNATURE_URL=https://www.apache.org/dist/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz.asc
MVN_BIN_DIR=$JAVA_TOOLCHAIN_DIR/apache-maven-$MVN_VERSION/bin

function get_ant {
	echo -e "Getting ANT..."
	mkdir -p $TOOLCHAIN_UPSTREAM_FILES_DIR
	cd $TOOLCHAIN_UPSTREAM_FILES_DIR
	curl -LO $ANT_URL
	curl -LO $ANT_CHECKSUM_URL
	curl -LO $ANT_SIGNATURE_URL
	ANT_CALCULATED_CHECKSUM=$(sha512sum $ANT_TAR | awk '{print $1}')
	ANT_DOWNLOADED_CHECKSUM=$(cat $ANT_CHECKSUM)
	if [ "$ANT_CALCULATED_CHECKSUM" == "$ANT_DOWNLOADED_CHECKSUM"  ]; then
            echo "ANT checksum matches"
        else
            echo "ANT checksum does not match"
	    cd $WORKING_DIR
            exit 1
        fi
	echo "Decompressing tar file..."
	tar -xzf $ANT_TAR  -C $JAVA_TOOLCHAIN_DIR
	cd $WORKING_DIR
}

function get_mvn {
	echo -e "\n\nGetting Maven..."
	mkdir -p $TOOLCHAIN_UPSTREAM_FILES_DIR
	cd $TOOLCHAIN_UPSTREAM_FILES_DIR
   	curl -LO $MVN_URL
   	curl -LO $MVN_CHECKSUM_URL
   	curl -LO $MVN_SIGNATURE_URL
	MVN_CALCULATED_CHECKSUM=$(sha512sum $MVN_TAR | awk '{print $1}')
	MVN_DOWNLOADED_CHECKSUM=$(cat $MVN_CHECKSUM)
	if [ "$MVN_CALCULATED_CHECKSUM" == "$MVN_DOWNLOADED_CHECKSUM"  ]; then
	    echo "Maven checksum matches"
        else
       	    echo "Maven checksum does not match"
	    cd $WORKING_DIR
            exit 1
        fi
	echo "Decompressing tar file..."
        tar -xzf $MVN_TAR -C $JAVA_TOOLCHAIN_DIR	
	cd $WORKING_DIR
}

function cleanup {
	if [ -d $JAVA_TOOLCHAIN_DIR  ]; then
		echo "Cleaning up stacks-java-toolchain directory..."
		rm -rf $JAVA_TOOLCHAIN_DIR
	fi
}

function add_upstream_tools_to_path {
	echo "Adding bin directories to the user path and /etc/profile"
	echo "PATH=$PATH:$ANT_BIN_DIR:$MVN_BIN_DIR; export PATH" >> /root/.bashrc
	echo "PATH=$PATH:$ANT_BIN_DIR:$MVN_BIN_DIR; export PATH" > /etc/profile
	export PATH=$PATH:$ANT_BIN_DIR:$MVN_BIN_DIR
	echo -e "Exporting: \n$PATH"
}

cleanup
get_ant
get_mvn
add_upstream_tools_to_path

