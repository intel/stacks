#!/bin/sh
set -ex

if [ ! -d /mnt/pmem0 ]
then
	echo "No PMEM devices are attached to the container on /mnt/pmem0, memcached will operate without PMEM support"
else
	# Take ownership of PMEM mount point, this is important on K8s environments since pmem-csi does not change permissions when provisioning
	sudo /usr/bin/change_fsdax_perms.sh
fi

if [ $# -eq 0 ]; then
	exec memcached
else
	set -- memcached "$@"
	exec "$@"
fi
