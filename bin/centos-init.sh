#! /bin/bash

curl -sSL 'https://raw.githubusercontent.com/wentjiang/shell-box/master/centos7/set-sources-cn.sh' | sh \
  && curl -sSL 'https://raw.githubusercontent.com/wentjiang/shell-box/master/centos7/install-base-pkgs.sh' | sh \
  && curl -sSL 'https://raw.githubusercontent.com/wentjiang/shell-box/master/centos7/install-openjdk.sh' | sh -s jre 8 231 11 5b13a193868b4bf28bcb45c792fce896 \
  && curl -sSL 'https://raw.githubusercontent.com/wentjiang/shell-box/master/sysfree/install-ejava.sh' | sh \
  && curl -sSL 'https://raw.githubusercontent.com/wentjiang/shell-box/master/centos7/set-timezone-cn.sh' | sh \
  && curl -sSL 'https://raw.githubusercontent.com/wentjiang/shell-box/master/centos7/set-locale-cn.sh' | sh
