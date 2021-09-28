#!/bin/bash

mkdir -p /root/projects/rhoar-getting-started/spring/spring-monitoring
cd /root/projects/rhoar-getting-started/spring/spring-monitoring

clear
echo 'echo Installing the latest Java runtime..' > /tmp/launch.sh
echo 'until ${JAVA_HOME}/bin/java --version >& /dev/null ; do sleep 1; echo -n . && source ~/.bashrc; done' >> /tmp/launch.sh
echo 'echo' >> /tmp/launch.sh
echo 'echo "Ready!"' >> /tmp/launch.sh
chmod a+x /tmp/launch.sh
clear
/tmp/launch.sh
source ~/.bashrc