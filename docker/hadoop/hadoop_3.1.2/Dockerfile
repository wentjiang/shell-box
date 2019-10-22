# CentOS with JDK 8

# build a new image with basic  centos
FROM wentjiang:jdk8
# who is the author
MAINTAINER wentjiang

ADD apache-hive-3.1.2-bin.tar.gz /opt/
ADD hadoop-3.1.2.tar.gz /opt/

RUN curl -sSL 'https://raw.githubusercontent.com/wentjiang/shell-box/master/docker/hadoop/hadoop_3.1.2/init_env.sh' | sh
