# Container for build
FROM centos:8 AS cassandra-builder

ARG http_proxy
ENV http_proxy=$http_proxy
ARG https_proxy
ENV https_proxy=$https_proxy

COPY scripts/build-cassandra-pmem.sh /opt

RUN dnf update -y && \
    dnf install java-1.8.0-openjdk ant maven git libpmem libpmemblk libpmemlog libpmemobj libpmempool libpmem-devel libpmemblk-devel libpmemlog-devel libpmemobj-devel libpmempool-devel libpmemobj++-devel  gcc-c++ make -y && \
    cd /opt && \
    ./build-cassandra-pmem.sh


# Cassandra container
FROM centos:8 AS cassandra-centos
LABEL maintainer="otc-swstacks@intel.com"

COPY scripts/docker-entrypoint.sh scripts/docker-healthcheck scripts/change_fsdax_perms.sh scripts/change_devdax_perms.sh scripts/change_persistent_dirs_perms.sh  /usr/local/bin/
COPY --from=cassandra-builder /tmp/cassandra-build/cassandra/bin /opt/cassandra-pmem/bin/
COPY --from=cassandra-builder /tmp/cassandra-build/cassandra/conf /opt/cassandra-pmem/conf/
COPY --from=cassandra-builder /tmp/cassandra-build/cassandra/lib /opt/cassandra-pmem/lib/
COPY --from=cassandra-builder /tmp/cassandra-build/cassandra/pylib /opt/cassandra-pmem/pylib/
COPY --from=cassandra-builder /tmp/cassandra-build/cassandra/tools /opt/cassandra-pmem/tools/
COPY --from=cassandra-builder /tmp/cassandra-build/cassandra/build/classes /opt/cassandra-pmem/build/classes/
COPY --from=cassandra-builder /tmp/cassandra-build/cassandra/build/apache-cassandra-4.0-alpha2-SNAPSHOT.jar /opt/cassandra-pmem/build/

# Adding user and sudo privileges to take ownership of pmem devices as cassandra-user
RUN dnf update -y && \
    dnf install java-1.8.0-openjdk libpmem libpmemblk libpmemlog libpmemobj libpmempool python3 sudo -y --setopt=install_weak_deps=False && \
    rpm -e xorg-x11-fonts-Type1 xorg-x11-font-utils libfontenc --nodeps && \
    useradd cassandra-user -d /home/cassandra-user && \
    mkdir -p /etc/sudoers.d && \
    echo 'cassandra-user ALL=(root) NOPASSWD: /usr/local/bin/change_fsdax_perms.sh,/usr/local/bin/change_devdax_perms.sh,/usr/local/bin/change_persistent_dirs_perms.sh' > /etc/sudoers.d/cassandra-user &&  \
    chown root:root /usr/local/bin/change_fsdax_perms.sh && \
    chmod 755 /usr/local/bin/change_fsdax_perms.sh && \
    chown root:root /usr/local/bin/change_devdax_perms.sh && \
    chmod 755 /usr/local/bin/change_devdax_perms.sh && \
    chown root:root /usr/local/bin/change_persistent_dirs_perms.sh && \
    chmod 755 /usr/local/bin/change_persistent_dirs_perms.sh && \
    # Creating data and logs directory
    cd /opt && \
    chown root:root -R /opt/cassandra-pmem && \
    mkdir /opt/cassandra-pmem/data && \
    mkdir /opt/cassandra-pmem/logs && \
    chown cassandra-user -R /opt/cassandra-pmem/data && \
    chown cassandra-user -R /opt/cassandra-pmem/logs && \
    # Changing permissions for bin, removing windows specific files and unnecessary files which are replaced by templates
    chmod 0755 /opt/cassandra-pmem/bin/* && \
    rm -rf /opt/cassandra-pmem/lib/sigar-bin/*.dll && \
    rm -rf /opt/cassandra-pmem/lib/sigar-bin/*.lib && \
    rm /opt/cassandra-pmem/bin/*.bat && \
    rm /opt/cassandra-pmem/bin/*.ps1 && \
    rm /opt/cassandra-pmem/tools/bin/*.bat && \
    rm /opt/cassandra-pmem/conf/cassandra.yaml && \
    rm /opt/cassandra-pmem/conf/jvm-server.options && \
    rm /opt/cassandra-pmem/conf/jvm8-server.options && \
    rm /opt/cassandra-pmem/conf/jvm11-server.options && \
    # Updating PATH for cassandra-user when login into the container
    mkdir -p /home/cassandra-user/ && \
    chown cassandra-user:cassandra-user -R /home/cassandra-user/ && \
    echo "PATH=$PATH:/opt/cassandra-pmem/bin:/opt/cassandra-pmem/tools/bin" > /home/cassandra-user/.bashrc

COPY conf/cassandra-template.yaml conf/jvm-server.options-template conf/jvm8-server.options conf/jvm11-server.options  /opt/cassandra-pmem/conf/
RUN chown cassandra-user -R /opt/cassandra-pmem/conf/ 
COPY licenses/ /home/cassandra-user/licenses/

HEALTHCHECK --interval=30s CMD ["docker-healthcheck"]
EXPOSE 9042 7000
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
USER cassandra-user
CMD ["/opt/cassandra-pmem/bin/cassandra", "-f"]

