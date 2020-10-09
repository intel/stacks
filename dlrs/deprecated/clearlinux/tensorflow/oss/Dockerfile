ARG clear_ver
FROM clearlinux/stacks-clearlinux:$clear_ver

LABEL maintainer=otc-swstacks@intel.com

RUN swupd bundle-add curl sysadmin-basic devpkg-gperftools \
    git machine-learning-tensorflow devpkg-opencv \
    && ln -s /usr/lib64/libtcmalloc.so /usr/lib/libtcmalloc.so

# install additional python packages for ipython, seldon-core and jupyter notebook
RUN pip --no-cache-dir install ipython ipykernel matplotlib jupyter seldon-core && \
    python -m ipykernel.kernelspec

CMD 'bash'
