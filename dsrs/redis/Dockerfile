FROM centos:8 as redis-centos-builder

ENV REDIS_PMEMD="/tmp/redis"
ENV CFLAGS=" -O3 -falign-functions=32 -fno-lto -fno-math-errno -fno-semantic-interposition -fno-trapping-math "

RUN dnf update -y && \
    dnf install gcc make automake autoconf libtool git bzip2 ndctl-devel daxctl-devel numactl-devel -y && \
    curl -LO https://github.com/jemalloc/jemalloc/releases/download/4.5.0/jemalloc-4.5.0.tar.bz2 && \
    tar -xvf jemalloc-4.5.0.tar.bz2 && \
    cd jemalloc-4.5.0 && \
    ./configure --disable-initial-exec-tls && \
    make && make install && \
    git clone https://github.com/pmem/pmem-redis $REDIS_PMEMD && \
    cd $REDIS_PMEMD && \
    git submodule init && git submodule update && \
    make USE_NVM=yes install && \
    cp /usr/lib64/libnuma.so* /usr/local/lib64/


FROM centos:8 AS redis-centos
LABEL maintainer="otc-swstacks@intel.com"

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

COPY scripts/docker-entrypoint.sh scripts/docker-healthcheck /usr/local/bin/
COPY scripts/redis.conf /etc/redis/redis.conf
COPY --from=redis-centos-builder /usr/local/bin/ /usr/local/bin/
COPY --from=redis-centos-builder /usr/local/lib/ /usr/local/lib/
COPY --from=redis-centos-builder /usr/local/lib64/ /usr/local/lib64/

RUN echo "/usr/local/lib64" | tee -a /etc/ld.so.conf && \
    ldconfig && \
    chmod 755 /var/cache/ldconfig/ && \
    useradd redis-user && \ 
    mkdir -p /var/lib/redis && \
    mkdir -p /etc/redis && \
    chown redis-user:redis-user /var/lib/redis/

COPY licenses/ /home/redis-user/licenses/

HEALTHCHECK --interval=15s CMD ["docker-healthcheck"]
USER redis-user
ENTRYPOINT ["docker-entrypoint.sh"]
