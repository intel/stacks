#!/bin/bash
/opt/spark-3.0.2/sbin/start-master.sh
/opt/spark-3.0.2/sbin/start-slave.sh spark://$(echo "$(hostname -I)" | sed -e 's/\ //g' ):7077
