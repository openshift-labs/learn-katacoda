#!/bin/bash
GRAAL_VERSION=21.0.0.0

# export GRAALVM_HOME="/usr/local/graalvm-ce-java11-${GRAAL_VERSION}" && \
export MANDREL_HOME="/usr/local/mandrel-java11-${GRAAL_VERSION}-Final" && \
export GRAALVM_HOME="${MANDREL_HOME}" && \
export PATH=$MANDREL_HOME/bin:$PATH && \
echo "export MANDREL_HOME=$MANDREL_HOME" >> ~/.bashrc && \
echo "export GRAALVM_HOME=$MANDREL_HOME" >> ~/.bashrc && \
echo "export PATH=$MANDREL_HOME/bin:\$PATH" >> ~/.bashrc

# curl -w '' -sL https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAAL_VERSION}/graalvm-ce-java11-linux-amd64-${GRAAL_VERSION}.tar.gz | \
yum install glibc-devel zlib-devel gcc freetype-devel libstdc++ glibc -y && \
curl -w '' -sL https://github.com/graalvm/mandrel/releases/download/mandrel-${GRAAL_VERSION}-Final/mandrel-java11-linux-amd64-${GRAAL_VERSION}-Final.tar.gz | \
  ( cd /usr/local; tar -xvzf - )
# $GRAALVM_HOME/bin/gu install native-image