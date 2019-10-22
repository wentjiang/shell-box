#! /bin/bash

# hadoop env
mkdir -p /opt/data/hadoop/hdfs/name
mkdir -p /opt/data/hadoop/hdfs/data
mkdir -p /opt/data/hadoop/tmp
mkdir -p /var/log/hadoop
mkdir -p /var/log/yarn
mkdir -p /var/log/hive

export HADOOP_HOME=/opt/hadoop-3.1.2
export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
export HADOOP_LOG_DIR=/var/log/hadoop
export YARN_LOG_DIR=/var/log/yarn
export YARN_CONF_DIR=${HADOOP_HOME}/etc/hadoop
export HIVE_HOME=/opt/hive
export HIVE_CONF_DIR=${HIVE_HOME}/conf
