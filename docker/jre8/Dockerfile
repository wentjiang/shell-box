FROM centos:7

MAINTAINER wentjiang<wentjiang@sina.com>

RUN curl -sSL 'https://raw.githubusercontent.com/wentjiang/shell-box/master/centos7/set-sources-cn' | sh \
  && curl -sSL 'https://raw.githubusercontent.com/wentjiang/shell-box/master/centos7/install-base-pkgs' | sh \
  && curl -sSL 'https://raw.githubusercontent.com/wentjiang/shell-box/master/centos7/install-oracle-java' | sh -s jre 8 231 11 5b13a193868b4bf28bcb45c792fce896 \
  && curl -sSL 'https://raw.githubusercontent.com/wentjiang/toolbox/master/sysfree/install-ejava' | sh \
  && curl -sSL 'https://raw.githubusercontent.com/wentjiang/toolbox/master/centos7/set-timezone-cn' | sh \
  && curl -sSL 'https://raw.githubusercontent.com/wentjiang/toolbox/master/centos7/set-locale-cn' | sh

ENV TIMEZONE=Asia/Shanghai TZ=Asia/Shanghai \
    LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8 LANGUAGE=zh_CN.UTF-8:zh:en_US:en \
    JAVA_HOME=/usr/java/jre1.8.0_231