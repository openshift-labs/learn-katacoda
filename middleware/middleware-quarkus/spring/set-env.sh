#!/bin/bash

GRAAL_VERSION=21.0.0.2
JAVA_VERSION=11.0.10+9

export JAVA_HOME="/usr/local/jdk-${JAVA_VERSION}"
export PATH=$JAVA_HOME/bin:$PATH
echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
echo "export PATH=$JAVA_HOME/bin:\$PATH" >> ~/.bashrc

export GRAALVM_HOME="/usr/local/graalvm-ce-java11-${GRAAL_VERSION}"
export PATH=$GRAALVM_HOME/bin:$PATH
echo "export GRAALVM_HOME=$GRAALVM_HOME" >> ~/.bashrc
echo "export PATH=$GRAALVM_HOME/bin:\$PATH" >> ~/.bashrc

clear
echo 'echo Installing the latest Java runtime..' > /tmp/launch.sh
echo 'until ${JAVA_HOME}/bin/java --version >& /dev/null ; do sleep 1; echo -n .; done' >> /tmp/launch.sh
echo 'echo' >> /tmp/launch.sh
echo 'echo "Ready!"' >> /tmp/launch.sh
chmod a+x /tmp/launch.sh
clear
/tmp/launch.sh
