#!/usr/bin/env bash

if [[ -f "./hadoop_build_config.sh" ]]; then
  . "hadoop_build_config.sh"
else
  echo "ERROR: Cannot execute ./hadoop_build_config.sh" 2>&1
  exit 1
fi

if [[ ! -f "hadoop-${HADOOP_VERSION}.tar.gz" ]]; then
	mv ${HADOOP_SOURCE_HOME}/hadoop-dist/target/hadoop-${HADOOP_VERSION}.tar.gz ./
else 
	echo "hadoop-${HADOOP_VERSION}.tar.gz exist"
fi

if [[ ! -d "hadoop-${HADOOP_VERSION}" ]]; then
	tar xf hadoop-${HADOOP_VERSION}.tar.gz
	echo "tar hadoop-${HADOOP_VERSION}.tar.gz"
else 
	echo "hadoop-${HADOOP_VERSION} exist"
fi


current_path=$(pwd -P)

if [[ -f "Dockerfile" ]]; then
	echo "Dockerfile is exist ,please check"
#	exit 1
fi

cat>Dockerfile<<EOF
FROM openjdk:8
WORKDIR /usr/local
COPY ./hadoop-${HADOOP_VERSION} /usr/local/hadoop
RUN export HADOOP_HOME=/usr/local/hadoop && $PATH:$HADOOP_HOME/bin
EOF

docker build -t "hadoop-image:$(date +%Y%m%d%H%M%S)" ./


#脚本完成之后调用清理操作
function clean_resource {
	rm -rf hadoop-${HADOOP_VERSION}
	rm -rf Dockerfile
	rm -rf tar hadoop-${HADOOP_VERSION}.tar.gz
}
