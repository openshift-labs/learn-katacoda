#!/bin/bash

mkdir -p /root/projects/quarkus
cd /root/projects/quarkus

wget -O /tmp/graalvm.tar.gz https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-21.0.0.2/graalvm-ce-java11-linux-amd64-21.0.0.2.tar.gz && \
pushd /usr/local && \
tar -xvzf /tmp/graalvm.tar.gz && \
rm -rf /tmp/graalvm.tar.gz && \
export GRAALVM_HOME="/usr/local/graalvm-ce-java11-21.0.0.2" && \
export PATH=$GRAALVM_HOME/bin:$PATH && \
$GRAALVM_HOME/bin/gu install native-image && \
echo "export GRAALVM_HOME=$GRAALVM_HOME" >> ~/.bashrc && \
echo "export PATH=$GRAALVM_HOME/bin:\$PATH" >> ~/.bashrc && \
popd

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
