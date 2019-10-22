FROM centos:7

MAINTAINER wentjiang<wentjiang@sina.com>

RUN curl -sSL 'https://raw.githubusercontent.com/wentjiang/shell-box/master/centos7/set-sources-cn.sh' | sh \
  && curl -sSL 'https://raw.githubusercontent.com/wentjiang/shell-box/master/centos7/install-base-pkgs.sh' | sh \
  && curl -sSL 'https://raw.githubusercontent.com/wentjiang/shell-box/master/centos7/install-openjdk.sh' | sh -s jre 8 231 11 5b13a193868b4bf28bcb45c792fce896 \
  && curl -sSL 'https://raw.githubusercontent.com/wentjiang/shell-box/master/sysfree/install-ejava.sh' | sh \
  && curl -sSL 'https://raw.githubusercontent.com/wentjiang/shell-box/master/centos7/set-timezone-cn.sh' | sh \
  && curl -sSL 'https://raw.githubusercontent.com/wentjiang/shell-box/master/centos7/set-locale-cn.sh' | sh

ENV TIMEZONE=Asia/Shanghai TZ=Asia/Shanghai \
    LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8 LANGUAGE=zh_CN.UTF-8:zh:en_US:en \
    JAVA_HOME=/usr/java/jre1.8.0_231