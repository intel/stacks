# Dockerfile for spark-openblas
FROM centos:8 AS openblas-builder

ARG http_proxy
ENV http_proxy=$http_proxy
ARG https_proxy
ENV https_proxy=$https_proxy

COPY scripts/build-openblas.sh /opt

RUN dnf install -y 'dnf-command(config-manager)' && \
    dnf config-manager --set-enabled PowerTools && \
    dnf install epel-release libgfortran gcc-gfortran compat-libgfortran-48 -y && \
    dnf update -y && \
    dnf group install "Development Tools" -y && \
    /opt/build-openblas.sh "0.3.10"

FROM centos:8 AS hadoop-builder

ARG http_proxy
ENV http_proxy=$http_proxy
ARG https_proxy
ENV https_proxy=$https_proxy

COPY scripts/build-custom-hadoop.sh /opt
COPY scripts/patches/ /tmp/patches/

RUN dnf install -y 'dnf-command(config-manager)' && \
    dnf config-manager --set-enabled PowerTools && \
    dnf install epel-release -y && \
    dnf update -y && \
    dnf install java-11-openjdk-devel maven openssh libpmemobj dh-autoreconf nasm git gcc gcc-c++ make perl pcre-devel perl-core zlib-devel pkgconf openssl openssl-devel which patch -y && \
    /opt/build-custom-hadoop.sh 


FROM centos:8 AS spark-openblas-builder

ARG http_proxy
ENV http_proxy=$http_proxy
ARG https_proxy
ENV https_proxy=$https_proxy

COPY scripts/build-spark-openblas.sh /opt

RUN dnf install -y 'dnf-command(config-manager)' && \
    dnf config-manager --set-enabled PowerTools && \
    dnf install epel-release -y && \
    dnf update -y && \
    dnf install java-11-openjdk-devel maven openssh libpmemobj dh-autoreconf nasm git -y && \
    /opt/build-spark-openblas.sh "3.0.0"

FROM centos:8 as spark-centos
LABEL maintainer="otc-swstacks@intel.com"

ENV SPARK_VERSION=3.0.0
ENV HADOOP_VERSION=3.2.0

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION/
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME 
ENV HADOOP_COMMON_HOME=$HADOOP_HOME 

ENV HADOOP_HDFS_HOME=$HADOOP_HOME 
ENV YARN_HOME=$HADOOP_HOME 
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native 
ENV PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin 
ENV HADOOP_INSTALL=$HADOOP_HOME 

ENV HDFS_NAMENODE_USER="analytics"
ENV HDFS_DATANODE_USER="analytics"
ENV HDFS_SECONDARYNAMENODE_USER="analytics"
ENV YARN_RESOURCEMANAGER_USER="analytics"
ENV YARN_NODEMANAGER_USER="analytics"

ENV SPARK_HOME=/opt/spark-$SPARK_VERSION/
ENV YARN_CONF_DIR=/opt/hadoop-$HADOOP_VERSION/etc/hadoop
ENV HADOOP_CONF_DIR=/opt/hadoop-$HADOOP_VERSION/etc/hadoop
ENV PATH=$PATH:/opt/spark-$SPARK_VERSION/bin/:/opt/hadoop-$HADOOP_VERSION/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/

COPY --from=spark-openblas-builder /tmp/spark-build/spark-$SPARK_VERSION  /opt/spark-$SPARK_VERSION
COPY --from=hadoop-builder /tmp/hadoop-build/hadoop-$HADOOP_VERSION-src/hadoop-dist/target/hadoop-$HADOOP_VERSION/  /opt/hadoop-$HADOOP_VERSION
COPY --from=hadoop-builder /usr/local/lib/libprotobuf*  /usr/local/lib/
COPY --from=hadoop-builder /usr/local/lib/libprotobuf-lite*  /usr/local/lib/
COPY --from=hadoop-builder /usr/local/lib/libprotoc*  /usr/local/lib/
COPY --from=hadoop-builder /usr/local/bin/protoc  /usr/local/bin/protoc
COPY --from=openblas-builder /opt/OpenBLAS/lib/* /usr/lib64/
COPY --from=openblas-builder /opt/OpenBLAS/include/* /usr/include/openblas/

COPY conf/spark-openblas/* /opt/spark-$SPARK_VERSION/etc/spark/
COPY conf/hadoop/* /opt/hadoop-$HADOOP_VERSION/etc/hadoop/
COPY scripts/start-single-node-analytics.sh scripts/start-ssh.sh scripts/spark-shell-openblas.sh scripts/hadoop-mapred-example.sh scripts/spark-submit-openblas-example.sh scripts/setup-cluster-node.sh scripts/append-host.sh /usr/local/sbin/
COPY conf/cluster-templates/ /opt/cluster-templates/

RUN dnf update -y && \
    dnf install java-11-openjdk-devel openssh-clients openssh-server sudo gcc python3 libgfortran compat-libgfortran-48 --setopt=install_weak_deps=False -y && \
    rpm -e xorg-x11-fonts-Type1 xorg-x11-font-utils libfontenc --nodeps && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    # Enabling OpenBLAS
    ln -sf /usr/lib64/libopenblas.so /usr/lib64/libblas.so && \
    ln -sf /usr/lib64/libopenblas.so /usr/lib64/libblas.so.3 && \
    ln -sf /usr/lib64/libopenblas.so /usr/lib64/libblas.so.3.5 && \
    ln -sf /usr/lib64/libopenblas.so /usr/lib64/liblapack.so && \
    ln -sf /usr/lib64/libopenblas.so /usr/lib64/liblapack.so.3 && \
    ln -sf /usr/lib64/libopenblas.so /usr/lib64/liblapack.so.3.5 && \
    # Creating container user
    useradd analytics && \
    chown analytics:analytics  -R /opt/spark-$SPARK_VERSION/ && \
    chown analytics:analytics  -R /opt/hadoop-$HADOOP_VERSION/ && \
    chmod ug+rwx -R /opt/* && \
    # Allow Analytics user to run start-single-node-analytics.sh
    mkdir -p /etc/sudoers.d && \
    echo 'analytics ALL=(root) NOPASSWD: /usr/local/sbin/start-single-node-analytics.sh,/usr/local/sbin/start-ssh.sh,/usr/local/sbin/append-host.sh *' > /etc/sudoers.d/analytics &&  \
    chown root:root /usr/local/sbin/start-single-node-analytics.sh && \
    chown root:root /usr/local/sbin/start-ssh.sh && \
    chown root:root /usr/local/sbin/append-host.sh && \
    chmod 755 /usr/local/sbin/start-single-node-analytics.sh && \
    chmod 755 /usr/local/sbin/start-ssh.sh && \
    chmod 755 /usr/local/sbin/append-host.sh && \
    # Disabling password auth for ssh
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
    # Replicating configuration files on conf
    cp /opt/spark-3.0.0/etc/spark/* /opt/spark-3.0.0/conf/ && \
    # Adding spark bin and sbin to path
    echo "PATH=$PATH:/opt/spark-$SPARK_VERSION/bin/:/opt/hadoop-$HADOOP_VERSION/bin" > /etc/environment 
   
COPY licenses/ /home/analytics/licenses/    

USER analytics
CMD ["bash"]
