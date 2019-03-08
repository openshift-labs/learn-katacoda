#!/bin/bash
GRAALVM_ARCHIVE='https://github.com/oracle/graal/releases/download/vm-1.0.0-rc12/graalvm-ce-1.0.0-rc12-linux-amd64.tar.gz'
GRAALVM_BASENAME='graalvm-ce-1.0.0-rc12'

echo "install gcc and deps"
yum --enablerepo=extras install epel-release -y
yum install gcc -y
yum install zlib-devel -y

echo "setup GraalVM Environment"
wget $GRAALVM_ARCHIVE -O /tmp/graalvm.tar.gz
tar -C /usr/local -xzf /tmp/graalvm.tar.gz
echo "export GRAALVM_HOME=/usr/local/\$GRAALVM_BASENAME" >> ~/.bashrc
. ~/.bashrc

# pre-populate maven repos by building a sample project
TMPDIR=$(mktemp -d)
pushd $TMPDIR
mvn io.quarkus:quarkus-maven-plugin:0.11.0:create \
    -DprojectGroupId=org.acme \
    -DprojectArtifactId=getting-started \
    -DclassName="org.acme.quickstart.GreetingResource" \
    -Dpath="/hello"

mvn -q -fn dependency:resolve-plugins dependency:resolve \
    dependency:go-offline clean compile package 

# and once for the native image

mvn -q -fn dependency:resolve-plugins dependency:resolve \
    dependency:go-offline clean compile package -Pnative

popd