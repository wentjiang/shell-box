#! /bin/bash

JAVA_PACKAGE=$1
JAVA_VERSION=$2 
JAVA_UPDATE=$3 
JAVA_BUILD=$4
DIR=$5
JAVA_FILE=${JAVA_PACKAGE}-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.rpm
JAVA_HOME=/usr/java/${JAVA_PACKAGE}1.${JAVA_VERSION}.0_${JAVA_UPDATE}
JRE_RM_PATH="$JAVA_HOME"
if [ "$JAVA_PACKAGE" = "jdk" ]; then
  JRE_RM_PATH="$JRE_RM_PATH/jre"
fi

curl -SL -o /tmp/${JAVA_FILE} https://download.oracle.com/otn/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/$DIR/${JAVA_FILE} \
  -F "AuthParam=1571293533_26cd5776050b7306a8bd0ac8c5663d2c" \
  && yum localinstall -y /tmp/${JAVA_FILE} \
  && rm -rf /tmp/${JAVA_FILE} \
  && rm -rf $JAVA_HOME/*src.zip \
        $JAVA_HOME/lib/missioncontrol \
        $JAVA_HOME/lib/visualvm \
        $JAVA_HOME/lib/jconsole.jar \
        $JAVA_HOME/lib/*javafx* \
  && rm -rf $JRE_RM_PATH/lib/plugin.jar \
        $JRE_RM_PATH/lib/ext/jfxrt.jar \
        $JRE_RM_PATH/bin/javaws \
        $JRE_RM_PATH/lib/javaws.jar \
        $JRE_RM_PATH/lib/desktop \
        $JRE_RM_PATH/plugin \
        $JRE_RM_PATH/lib/deploy* \
        $JRE_RM_PATH/lib/*javafx* \
        $JRE_RM_PATH/lib/*jfx* \
        $JRE_RM_PATH/lib/amd64/libdecora_sse.so \
        $JRE_RM_PATH/lib/amd64/libprism_*.so \
        $JRE_RM_PATH/lib/amd64/libfxplugins.so \
        $JRE_RM_PATH/lib/amd64/libglass.so \
        $JRE_RM_PATH/lib/amd64/libgstreamer-lite.so \
        $JRE_RM_PATH/lib/amd64/libjavafx*.so \
        $JRE_RM_PATH/lib/amd64/libjfx*.so \
        $JRE_RM_PATH/bin/keytool \
        $JRE_RM_PATH/bin/orbd \
        $JRE_RM_PATH/bin/pack200 \
        $JRE_RM_PATH/bin/policytool \
        $JRE_RM_PATH/bin/rmid \
        $JRE_RM_PATH/bin/rmiregistry \
        $JRE_RM_PATH/bin/servertool \
        $JRE_RM_PATH/bin/tnameserv \
        $JRE_RM_PATH/bin/unpack200 \
        $JRE_RM_PATH/lib/jfr.jar \
        $JRE_RM_PATH/lib/jfr \
        $JRE_RM_PATH/lib/oblique-fonts

echo export JAVA_HOME=$JAVA_HOME >> /etc/profile
export JAVA_HOME=$JAVA_HOME