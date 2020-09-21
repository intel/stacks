#!/bin/bash
# Example for hadoop on single node cluster
hadoop fs -mkdir /input
hadoop fs -put $HADOOP_HOME/*.txt /input
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples*.jar  wordcount /input /output
hadoop fs -cat /output/*
