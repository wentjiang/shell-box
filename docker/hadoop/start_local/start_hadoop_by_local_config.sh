#! /bin/bash

#按照本地的配置文件启动打包好的hadoop

IMAGE_TAG=$1
IMAGE="hadoop-image:${IMAGE_TAG}"
docker run -it \
-v ~/develop/hadoop-3.1.2/etc/hadoop:/usr/local/hadoop/etc/hadoop \
-e HADOOP_HOME:/usr/local/hadoop \

$IMAGE \
export PATH=$PATH:$HADOOP_HOME