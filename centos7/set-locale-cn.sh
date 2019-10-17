#! /bin/bash

yum install -y kde-l10n-Chinese \
  && yum reinstall -y glibc-common \
  && localedef -i zh_CN -f UTF-8 zh_CN.UTF-8 \
  && sed -i 's/LANG=.*/LANG="zh_CN.UTF-8"/g' /etc/locale.conf \
  && echo export LANG=zh_CN.UTF-8 >> /etc/profile \
  && echo export LC_ALL=zh_CN.UTF-8 >> /etc/profile \
  && echo export LANGUAGE=zh_CN.UTF-8:zh:en_US:en >> /etc/profile