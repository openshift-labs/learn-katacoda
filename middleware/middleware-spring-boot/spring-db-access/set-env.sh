#!/bin/bash

mkdir -p /root/projects/rhoar-getting-started/spring/spring-db-access
cd /root/projects/rhoar-getting-started/spring/spring-db-access

# Install Java 11
wget -O /tmp/jdk.tar.gz https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.10%2B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.10_9.tar.gz && \
pushd /usr/local && \
tar -xvzf /tmp/jdk.tar.gz && \
rm -rf /tmp/jdk.tar.gz && \
export JAVA_HOME="/usr/local/jdk-11.0.10+9" && \
export PATH=$JAVA_HOME/bin:$PATH && \
echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc && \
echo "export PATH=$JAVA_HOME/bin:\$PATH" >> ~/.bashrc && \
popd

clear