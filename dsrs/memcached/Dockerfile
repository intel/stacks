FROM centos:8 as memcached-centos-builder
RUN dnf update -y && \
    dnf install gcc make perl libevent-devel curl -y && \
    curl -LO https://www.memcached.org/files/memcached-1.6.5.tar.gz && \
    tar -zxvf memcached-1.6.5.tar.gz && \
    cd memcached-1.6.5 && \
    ./configure --prefix=/usr/local/memcached  && make && make test && make install

FROM centos:8 AS memcached-centos
LABEL maintainer="otc-swstacks@intel.com"

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/memcached/bin

COPY scripts/docker-entrypoint.sh /usr/local/bin/
COPY scripts/docker-healthcheck /usr/local/bin/

RUN dnf update -y && \
    dnf install libevent -y && \
    useradd memcached-user

COPY --from=memcached-centos-builder /usr/local/memcached /usr/local/memcached/
COPY licenses/ /home/memcached-user/licenses/

HEALTHCHECK --interval=15s CMD ["docker-healthcheck"]
USER memcached-user
ENTRYPOINT ["docker-entrypoint.sh"]

