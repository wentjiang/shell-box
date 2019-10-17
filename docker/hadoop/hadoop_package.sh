#!/usr/bin/env bash

HADOOP_SOURCE=/Users/wentao.jiang/workspace/githubspace/hadoop
cd ${HADOOP_SOURCE}

mvn clean
mvn package -Pdist -DskipTests -Dtar -Dmaven.javadoc.skip=true
