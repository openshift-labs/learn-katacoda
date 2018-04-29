#!/usr/bin/env bash

cd /tmp
[ -f OpenWhisk_CLI-latest-linux-386.tgz ] || \
    wget -N -nv https://github.com/apache/incubator-openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-linux-386.tgz
[ -f /usr/local/bin/wsk ] || sudo tar xzvf OpenWhisk_CLI-latest-linux-386.tgz -C /usr/local/bin wsk


git clone https://github.com/apache/incubator-openwhisk-devtools /tmp/openwhisk-devtools
cd /tmp/openwhisk-devtools/java-action-archetype \
    && mvn -DskipTests clean install  \
    && cd  \
    && rm -rf /tmp/openwhisk-devtools
