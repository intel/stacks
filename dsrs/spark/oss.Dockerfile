# Dockerfile for spark-openblas
FROM registry.access.redhat.com/ubi8/ubi-init AS openblas-builder

ARG http_proxy
ENV http_proxy=$http_proxy
ARG https_proxy
ENV https_proxy=$https_proxy

COPY scripts/build-openblas.sh /opt

RUN dnf update -y && \
    dnf install --setopt=ubi-8-appstream.module_hotfixes=true make gcc perl libgfortran gcc-gfortran  -y && \
    /opt/build-openblas.sh "0.3.15"


FROM registry.access.redhat.com/ubi8/ubi-init AS libgfortran-builder

ARG http_proxy
ENV http_proxy=$http_proxy
ARG https_proxy
ENV https_proxy=$https_proxy
ENV ftp_proxy=$http_proxy

COPY scripts/build-gcc.sh /opt

RUN dnf update -y && \
    dnf install --setopt=ubi-8-appstream.module_hotfixes=true make gcc gcc-c++ wget bzip2 diffutils binutils  -y && \
    /opt/build-gcc.sh



FROM registry.access.redhat.com/ubi8/ubi-init AS spark-builder

ARG http_proxy
ENV http_proxy=$http_proxy
ARG https_proxy
ENV https_proxy=$https_proxy

COPY scripts/build-spark.sh /opt

RUN dnf update -y && \
    dnf install java-11-openjdk java-11-openjdk-devel java-11-openjdk-headless  maven  -y && \
    /opt/build-spark.sh "3.0.2"


FROM registry.access.redhat.com/ubi8/ubi-init as spark-rhel
LABEL maintainer="otc-swstacks@intel.com"

ENV SPARK_VERSION=3.0.2

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk

ENV SPARK_HOME=/opt/spark-$SPARK_VERSION/
ENV PATH=$PATH:/opt/spark-$SPARK_VERSION/bin/
ENV LD_LIBRARY_PATH=/usr/lib64/:$LD_LIBRARY_PATH:

COPY --from=spark-builder /tmp/spark-build/spark-$SPARK_VERSION  /opt/spark-$SPARK_VERSION
COPY --from=openblas-builder /opt/OpenBLAS/lib/* /usr/lib64/
COPY --from=openblas-builder /opt/OpenBLAS/include/* /usr/include/openblas/
COPY --from=libgfortran-builder /opt/gcc-build/lib64/* /usr/lib64/

COPY conf/spark/* /opt/spark-$SPARK_VERSION/etc/spark/
COPY scripts/spark-submit-cluster.sh scripts/spark-submit-standalone.sh scripts/start-spark-single-node-cluster.sh /usr/local/sbin/

RUN dnf update -y && \
    dnf install --setopt=ubi-8-baseos.module_hotfixes=true --setopt=ubi-8-appstream.module_hotfixes=true  java-11-openjdk java-11-openjdk-devel java-11-openjdk-headless gcc python3 libgfortran hostname net-tools --setopt=install_weak_deps=False -y && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    # Enabling OpenBLAS
    ln -sf /usr/lib64/libopenblas.so.0 /usr/lib64/libblas.so && \
    ln -sf /usr/lib64/libopenblas.so.0 /usr/lib64/libblas.so.3 && \
    ln -sf /usr/lib64/libopenblas.so.0 /usr/lib64/libblas.so.3.5 && \
    ln -sf /usr/lib64/libopenblas.so.0 /usr/lib64/liblapack.so && \
    ln -sf /usr/lib64/libopenblas.so.0 /usr/lib64/liblapack.so.3 && \
    ln -sf /usr/lib64/libopenblas.so.0 /usr/lib64/liblapack.so.3.5 && \
    ldconfig && \
    # Creating container user
    useradd analytics && \
    chown analytics:analytics  -R /opt/spark-$SPARK_VERSION/ && \
    chmod ug+rwx -R /opt/* && \
    # Allow Analytics user to run start-single-node-analytics.sh and OpenShift compatibility
    mkdir -p /opt/spark-$SPARK_VERSION/logs && \
    chown -R analytics:root /opt/spark-$SPARK_VERSION/logs && \
    chmod -R 775 /opt/spark-$SPARK_VERSION/logs && \
    mkdir -p /opt/spark-$SPARK_VERSION/work && \
    chown -R analytics:root /opt/spark-$SPARK_VERSION/work && \
    chmod -R 775 /opt/spark-$SPARK_VERSION/work && \
    # Replicating configuration files on conf
    cp /opt/spark-$SPARK_VERSION/etc/spark/* /opt/spark-$SPARK_VERSION/conf/ && \
    # Adding spark bin and sbin to path
    echo "PATH=$PATH:/opt/spark-$SPARK_VERSION/bin/" > /etc/environment && \
    echo "LD_LIBRARY_PATH=/usr/lib64/:$LD_LIBRARY_PATH" > /etc/environment 
   
COPY licenses/ /home/analytics/licenses/    

USER analytics
CMD ["bash"]
