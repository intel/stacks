#!/bin/bash
set -xe

# Enabling ssh access
/usr/bin/ssh-keygen -A
/usr/sbin/sshd
rm -rf /run/nologin
su - analytics -c "echo -e '\n' | ssh-keygen -N '' "
su - analytics -c "cp /home/analytics/.ssh/id_rsa.pub /home/analytics/.ssh/authorized_keys"
echo 'A SSH key was generated and added to /home/analytics/.ssh/authorized_keys'

