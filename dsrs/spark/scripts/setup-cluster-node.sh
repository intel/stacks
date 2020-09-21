#!/bin/bash

# Script for setting up a Hadoop and Spark cluster with Yarn
# Usage:
#        setup-cluster-node.sh -m "<master1-hostname>,<master1-ip>" -w "<worker1-hostname>,<worker1-ip>:<worker2-hostname>,<worker2-ip>,..." -k "<ssh-master-pubkey>"

TEMPLATES_DIR="/opt/cluster-templates"
TMP_TEMPLATES_DIR="/tmp/cluster-templates"
HADOOP_CONF_DIR="/opt/hadoop-3.2.0/etc/hadoop/"


while getopts r:m:w:k: option
do
case "${option}"
in
m) MASTER=${OPTARG};;
w) WORKERS=${OPTARG};;
k) SSH_PUB_KEY=${OPTARG};;
esac
done

if [  -z ${MASTER+x}   ]; then
   echo "Master not set"
   echo "Usage:"
   echo '        setup-cluster-node.sh -m "<master1-hostname>,<master1-ip>" -w "<worker1-hostname>,<worker1-ip>:<worker2-hostname>,<worker2-ip>,..." -k "<ssh-master-pubkey>"'
   exit 1
fi

if [  -z ${WORKERS+x}   ]; then
   echo "Workers not set"
   echo "Usage:"
   echo '        setup-cluster-node.sh -m "<master1-hostname>,<master1-ip>" -w "<worker1-hostname>,<worker1-ip>:<worker2-hostname>,<worker2-ip>,..." -k "<ssh-master-pubkey>"'
   exit 1
fi

if [ -d $TMP_TEMPLATES_DIR  ]; then
   rm -rf $TMP_TENPLATES_DIR
fi


# Setting up master on config files
MASTER_HOSTNAME=$(echo $MASTER | awk -F',' '{print $1}')
MASTER_IP=$(echo $MASTER | awk -F',' '{print $2}')
cp -r $TEMPLATES_DIR $TMP_TEMPLATES_DIR
sed -i "s/<master-ip>/$MASTER_HOSTNAME/g" $TMP_TEMPLATES_DIR/hadoop/*
# Adding master to /etc/hosts
sudo /usr/local/sbin/append-host.sh $MASTER
# Creating  masters file
echo "$MASTER_HOSTNAME" | sed 's/,/\n/g' > $HADOOP_CONF_DIR/masters
echo "Master hostname: $MASTER_HOSTNAME Master IP: $MASTER_IP"


# Setting up Workers on config files
WORKERS_ARRAY=($(echo $WORKERS | tr ":" "\n"))

rm -rf $HADOOP_CONF_DIR/workers

for i in "${WORKERS_ARRAY[@]}"
do
    # Adding worker to /etc/hosts
    sudo /usr/local/sbin/append-host.sh $i
    WORKER_HOSTNAME=$(echo $i | awk -F',' '{print $1}')
    WORKER_IP=$(echo $i | awk -F',' '{print $2}')
    # Creating workers file
    echo "$WORKER_HOSTNAME" >> $HADOOP_CONF_DIR/workers
    echo "Worker hostname: $WORKER_HOSTNAME Worker IP: $WORKER_IP"
done

echo "/etc/hosts"
cat /etc/hosts

# Copying conf files 
cp $TMP_TEMPLATES_DIR/hadoop/core-site.xml $HADOOP_CONF_DIR/core-site.xml
cp $TMP_TEMPLATES_DIR/hadoop/hdfs-site.xml  $HADOOP_CONF_DIR/hdfs-site.xml
cp $TMP_TEMPLATES_DIR/hadoop/mapred-site.xml  $HADOOP_CONF_DIR/mapred-site.xml
cp $TMP_TEMPLATES_DIR/hadoop/yarn-site.xml $HADOOP_CONF_DIR/yarn-site.xml

# Starting SSH service
sudo /usr/local/sbin/start-ssh.sh
if [  -z ${SSH_PUB_KEY+x}   ]; then
   echo "Master SSH pubkey not provided, you should add your pubkey manually on /home/analytics/.ssh/authorized_keys"
else
   mkdir -p /home/analytics/.ssh/
   echo $SSH_PUB_KEY >> /home/analytics/.ssh/authorized_keys
   echo 'Added provided Master SSH pubkey to /home/analytics/.ssh/authorized_keys'
fi

mkdir -p /home/analytics/hadoop/data/nameNode
mkdir -p /home/analytics/hadoop/data/dataNode

cp /opt/spark-3.0.0/etc/spark/* /opt/spark-3.0.0/conf/
