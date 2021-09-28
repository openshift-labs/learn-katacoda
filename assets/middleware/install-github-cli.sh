#!/bin/bash

GH_CLI_VERSION=1.13.1
GH_CLI_NM=gh_${GH_CLI_VERSION}_linux_amd64
GH_CLI_FILE_NM=${GH_CLI_NM}.tar.gz

export GH_CLI_HOME="/usr/local/$GH_CLI_NM" && \
export PATH=$GH_CLI_HOME/bin:$PATH && \
echo "export GH_CLI_HOME=$GH_CLI_HOME" >> ~/.bashrc && \
echo "export PATH=$GH_CLI_HOME/bin:\$PATH" >> ~/.bashrc

curl -w '' -sL https://github.com/cli/cli/releases/download/v$GH_CLI_VERSION/$GH_CLI_FILE_NM | \
  ( cd /usr/local; tar -xvzf - )