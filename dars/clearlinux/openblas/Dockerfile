FROM clearlinux/stacks-clearlinux:30960 AS base-image
ARG swupd_args

# Move to validated version of Clearlinux, or moving to latest Clear Linux release
RUN [[ -z "$swupd_args" ]] &&  swupd update --no-boot-update || swupd update --no-boot-update -V $swupd_args

FROM base-image AS builder

# Install additional content in a target directory
# using the os version from the minimal base
RUN source /usr/lib/os-release && \
    mkdir /install_root \
    && swupd os-install -V ${VERSION_ID} \
    --path /install_root --statedir /swupd-state \
    --bundles=big-data-basic,cpio,os-core-update,python-basic-dev,which --no-boot-update \
    && rm -rf /install_root/var/lib/swupd/*

FROM base-image
LABEL maintainer=otc-swstacks@intel.com

ENV HOME=/root

# Configure openjdk11
ENV JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Environment variables to point to Hadoop,
# Spark and YARN installation and configuration
ENV HADOOP_HOME=/usr
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV HADOOP_DEFAULT_LIBEXEC_DIR=$HADOOP_HOME/libexec
ENV HADOOP_IDENT_STRING=root
ENV HADOOP_LOG_DIR=/var/log/hadoop
ENV HADOOP_PID_DIR=/var/log/hadoop/pid
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"

ENV HDFS_DATANODE_USER=root
ENV HDFS_NAMENODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root

ENV SPARK_HOME=/usr/share/apache-spark
ENV SPARK_CONF_DIR=/etc/spark

ENV YARN_RESOURCEMANAGER_USER=root
ENV YARN_NODEMANAGER_USER=root

COPY --from=builder /install_root /

COPY dars.ld.so.conf /etc/ld.so.conf

RUN ldconfig

RUN mkdir -p /etc/spark /etc/hadoop && \
    cp /usr/share/defaults/hadoop/log4j.properties /etc/hadoop && \
    cp /usr/share/apache-spark/conf/log4j.properties.template /etc/spark/log4j.properties

COPY spark_conf/* /etc/spark/
COPY hadoop_conf/* /etc/hadoop/

# clean up unnecesary binaries
RUN swupd clean
CMD ["/bin/bash"]
