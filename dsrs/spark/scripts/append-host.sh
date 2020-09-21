#!/bin/bash

if [  -z ${1+x}   ]; then
   echo 'No host to append to /etc/hosts, provide a host in the fllowing way "<hostname>,<ip-address>"'
   exit 1
fi

HOSTNAME=$(echo $1 | awk -F',' '{print $1}')
IP=$(echo $1 | awk -F',' '{print $2}')

echo "$IP   $HOSTNAME" >> /etc/hosts


