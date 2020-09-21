#!/bin/bash
# Script for staring Spark, Hadoop and Yarn services on single node configuration
set -xe

# Enabling ssh access
/usr/bin/ssh-keygen -A
/usr/sbin/sshd
rm -rf /run/nologin
su - analytics -c "echo -e '\n' | ssh-keygen -N '' "
su - analytics -c "cp /home/analytics/.ssh/id_rsa.pub /home/analytics/.ssh/authorized_keys"

# Create hdfs namenode
sleep 10s
su - analytics -c "mkdir /home/analytics/hadoop-data"
cd /home/analytics/hadoop-data
su - analytics -c "hadoop namenode -format"
su - analytics -c "start-dfs.sh"
su - analytics -c "start-yarn.sh"
su - analytics -c "/opt/spark-3.0.0/sbin/start-all.sh"




