#! /bin/bash

# MAINTAINER Ma Qian<maqian258@gmail.com>

JAVACMD=`type java |awk '{print $(NF)}'`
$JAVACMD -version > /dev/null 2>&1
if [ $? -ne 0 ]; then
    JAVACMD="$JAVA_HOME/bin/java"
fi

$JAVACMD -version > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo could not find java program in your system, please install a java package or set JAVA_HOME environment variable. && exit 1
fi

curl -sSL -o /usr/local/bin/java 'https://raw.githubusercontent.com/wentjiang/shell-box/master/bin/ejava' \
  && sed -i"" "s@JAVACMD=.*@JAVACMD=$JAVACMD@g" /usr/local/bin/java \
  && chmod +x /usr/local/bin/java