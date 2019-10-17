#! /bin/bash

echo ZONE="Asia/Shanghai" > /etc/sysconfig/clock \
&& "cp" -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo export TIMEZONE=Asia/Shanghai >> /etc/profile \
&& echo export TZ=Asia/Shanghai >> /etc/profile