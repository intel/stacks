# Container for runtime
FROM clearlinux:latest AS runtime-builder

ARG swupd_args

# Move to latest Clear Linux release
RUN swupd update --no-boot-update $swupd_args

# Installing dependencies for runtime
RUN source /usr/lib/os-release \
    && mkdir /install_root \
    && swupd os-install  \
    --path /install_root --statedir /swupd-state \
    --bundles=os-core,memcached,sudo,procps-ng --no-boot-update

FROM scratch
COPY --from=runtime-builder /install_root /
MAINTAINER otc-swstacks@intel.com

COPY scripts/docker-entrypoint.sh /usr/bin/
COPY scripts/docker-healthcheck /usr/bin/
COPY scripts/change_fsdax_perms.sh /usr/bin/

RUN useradd memcached-user && \
    mkdir -p /etc/sudoers.d && \
    chmod 555 /usr/bin/change_fsdax_perms.sh && \
    chown root:root /usr/bin/change_fsdax_perms.sh && \
    echo 'memcached-user ALL=(root) NOPASSWD: /usr/bin/change_fsdax_perms.sh' > /etc/sudoers.d/memcached-user

HEALTHCHECK --interval=15s CMD ["docker-healthcheck"]
USER memcached-user
ENTRYPOINT ["docker-entrypoint.sh"]
