#!/bin/bash
GRAALVM_ARCHIVE='https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-21.1.0/graalvm-ce-java11-linux-amd64-21.1.0.tar.gz'
GRAALVM_BASENAME='graalvm-ce-java11-21.1.0'

echo "install gcc and deps"
yum --enablerepo=extras install epel-release -y
yum install gcc -y
yum install zlib-devel -y

echo "setup GraalVM Environment"
wget $GRAALVM_ARCHIVE -O /tmp/graalvm.tar.gz
tar -C /usr/local -xzf /tmp/graalvm.tar.gz
echo "export GRAALVM_HOME=/usr/local/$GRAALVM_BASENAME" >> ~/.bashrc
. ~/.bashrc
${GRAALVM_HOME}/bin/gu install native-image

# pre-populate maven repos by building a sample project
TMPDIR=$(mktemp -d)
pushd $TMPDIR
mvn io.quarkus:quarkus-maven-plugin:1.13.2.Final:create \
    -DprojectGroupId=org.acme \
    -DprojectArtifactId=getting-started \
    -DclassName="org.acme.quickstart.GreetingResource" \
    -Dpath="/hello" && \
mvn -q -f getting-started -fn dependency:resolve-plugins dependency:resolve \
    dependency:go-offline clean compile package -DskipTests && \
mvn -q -f getting-started -fn dependency:resolve-plugins dependency:resolve \
    dependency:go-offline clean compile package  -DskipTests -Pnative

echo "Quarkus install completed"
