#!/bin/bash
set -ex

if [ ! -d /mnt/pmem0 ]
then
	echo "No PMEM devices are attached to the container on /mnt/pmem0, memcached will operate without PMEM support"
else
	echo "Verifying Pmem is writable"
	echo "Hello World" > /mnt/pmem0/pmem_test
	rm /mnt/pmem0/pmem_test
fi

if [ $# -eq 0 ]; then
	exec redis-server /etc/redis/redis.conf
else
	set -- redis-server /etc/redis/redis.conf "$@"
	exec "$@"
fi