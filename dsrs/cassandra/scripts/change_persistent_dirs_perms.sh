#!/bin/bash
DATA_DIR="/opt/cassandra-pmem/data"
LOG_DIR="/opt/cassandra-pmem/logs"

/usr/bin/chown cassandra-user -R $DATA_DIR
/usr/bin/chown cassandra-user -R $LOG_DIR
