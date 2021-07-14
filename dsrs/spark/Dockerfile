# Dockerfile for spark-mkl
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
    dnf install java-11-openjdk java-11-openjdk-devel java-11-openjdk-headless  maven -y && \
    /opt/build-spark.sh "3.0.2"

FROM registry.access.redhat.com/ubi8/ubi-init as spark-rhel
LABEL maintainer="otc-swstacks@intel.com"

ENV SPARK_VERSION=3.0.2

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk

ENV SPARK_HOME=/opt/spark-$SPARK_VERSION/
ENV PATH=$PATH:/opt/spark-$SPARK_VERSION/bin/
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/native:/opt/intel/oneapi/mkl/latest/lib/intel64/:/opt/intel/oneapi/compiler/2021.2.0/linux/compiler/lib/intel64_lin/

COPY conf/oneAPI.repo /etc/yum.repos.d/

COPY --from=spark-builder /tmp/spark-build/spark-$SPARK_VERSION  /opt/spark-$SPARK_VERSION

COPY conf/spark/* /opt/spark-$SPARK_VERSION/etc/spark/
COPY scripts/spark-submit-cluster.sh scripts/spark-submit-standalone.sh scripts/start-spark-single-node-cluster.sh /usr/local/sbin/
COPY --from=libgfortran-builder /opt/gcc-build/lib64/* /usr/lib64/

RUN dnf update -y && \
    dnf install java-11-openjdk-devel gcc python3 intel-oneapi-mkl.x86_64 intel-oneapi-mkl-devel.x86_64 hostname net-tools --setopt=install_weak_deps=False -y && \
    dnf clean all -y && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    echo -e "/opt/intel/oneapi/mkl/latest/lib/intel64/\n/opt/intel/oneapi/compiler/2021.2.0/linux/compiler/lib/intel64_lin/" | tee -a /etc/ld.so.conf && \
    ln -s /opt/intel/oneapi/mkl/latest/lib/intel64/libmkl_rt.so /usr/lib64/libblas.so.3 && \
    ln -s /opt/intel/oneapi/mkl/latest/lib/intel64/libmkl_rt.so /usr/lib64/liblapack.so.3 && \
    ldconfig -v && \
    # Creating container user
    useradd analytics && \
    chown analytics:analytics  -R /opt/spark-$SPARK_VERSION/ && \
    #chown analytics:analytics  -R /opt/hadoop-$HADOOP_VERSION/ && \
    chown analytics:analytics  -R /opt/intel/ && \
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
    echo "export PATH=$PATH:/opt/spark-$SPARK_VERSION/bin/" > /etc/environment  
    

COPY licenses/ /home/analytics/licenses/

USER analytics
CMD ["bash"]
