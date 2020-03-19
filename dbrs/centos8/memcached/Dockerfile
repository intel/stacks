FROM centos as builder
RUN dnf update -y && \
    dnf install gcc make perl libevent-devel curl -y
RUN curl -LO https://www.memcached.org/files/memcached-1.5.21.tar.gz && \
    tar -zxvf memcached-1.5.21.tar.gz && \
    cd memcached-1.5.21 && \
    ./configure --prefix=/usr/local/memcached  && make && make test && make install

FROM centos
MAINTAINER otc-swstacks@intel.com

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/memcached/bin

COPY scripts/docker-entrypoint.sh /usr/bin/
COPY scripts/docker-healthcheck /usr/bin/
COPY scripts/change_fsdax_perms.sh /usr/bin/

RUN dnf update -y && \
    dnf install libevent sudo -y && \
    useradd memcached-user && \
    chmod 555 /usr/bin/change_fsdax_perms.sh && \
    chown root:root /usr/bin/change_fsdax_perms.sh && \
    echo 'memcached-user ALL=(root) NOPASSWD: /usr/bin/change_fsdax_perms.sh' > /etc/sudoers.d/memcached-user 

COPY --from=builder /usr/local/memcached /usr/local/memcached/

HEALTHCHECK --interval=15s CMD ["docker-healthcheck"]
USER memcached-user
ENTRYPOINT ["docker-entrypoint.sh"]
