#!/bin/bash
GRAAL_VERSION=21.0.0.2
curl -w '' -sL https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAAL_VERSION}/graalvm-ce-java11-linux-amd64-{$GRAAL_VERSION}.tar.gz | \
  ( cd /usr/local; tar -xvzf - ) && \
export GRAALVM_HOME="/usr/local/graalvm-ce-java11-${GRAAL_VERSION}" && \
export PATH=$GRAALVM_HOME/bin:$PATH && \
$GRAALVM_HOME/bin/gu install native-image && \
echo "export GRAALVM_HOME=$GRAALVM_HOME" >> ~/.bashrc && \
echo "export PATH=$GRAALVM_HOME/bin:\$PATH" >> ~/.bashrc