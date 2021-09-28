#!/bin/bash
export JAVA_HOME="/usr/local/jdk-11.0.10+9"
export PATH=$JAVA_HOME/bin:$PATH
echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
echo "export PATH=$JAVA_HOME/bin:\$PATH" >> ~/.bashrc
clear
echo 'echo Installing the latest Java runtime..' > /tmp/launch.sh
echo 'until ${JAVA_HOME}/bin/java --version >& /dev/null ; do sleep 1; echo -n .; done' >> /tmp/launch.sh
echo 'echo' >> /tmp/launch.sh
echo 'echo "Ready!"' >> /tmp/launch.sh
chmod a+x /tmp/launch.sh
cd ~/projects/
clear
/tmp/launch.sh
