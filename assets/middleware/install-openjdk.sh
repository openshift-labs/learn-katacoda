#!/bin/bash

export JAVA_HOME="/usr/local/jdk-11.0.10+9" && \
export PATH=$JAVA_HOME/bin:$PATH && \
echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc && \
echo "export PATH=$JAVA_HOME/bin:\$PATH" >> ~/.bashrc

curl -w '' -sL https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.10+9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.10_9.tar.gz | \
  ( cd /usr/local; tar -xvzf - )