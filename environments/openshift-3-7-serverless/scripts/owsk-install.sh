#!/bin/bash

git clone https://github.com/apache/incubator-openwhisk-devtools /tmp/openwhisk-devtools
cd /tmp/openwhisk-devtools/java-action-archetype \
    && mvn -DskipTests clean install  \
    && cd  \
    && rm -rf /tmp/openwhisk-devtools
cd /tmp/
mvn archetype:generate \
-DarchetypeGroupId=org.apache.openwhisk.java \
-DarchetypeArtifactId=java-action-archetype \
-DarchetypeVersion=1.0-SNAPSHOT \
-DgroupId=com.example \
-DartifactId=temp
cd temp
mvn package    
    
until $(oc status &> /dev/null); do sleep 1; done; oc adm policy add-cluster-role-to-user cluster-admin admin

mkdir -p /root/openwhisk/bin/
wget -c https://github.com/apache/incubator-openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-linux-386.tgz -P /root/installation
tar -zxvf /root/installation/OpenWhisk_CLI-latest-linux-386.tgz -C /root/openwhisk/bin/
oc new-project faas --display-name='FaaS - OpenShift Cloud Functions'
oc adm policy add-role-to-user admin developer -n faas
oc process -f https://git.io/vpnUR | oc create -f -

while $(oc get pods -n faas controller-0 | grep 0/1 > /dev/null); do sleep 1; done
while [ -z "`oc logs controller-0 -n faas 2>&1 | grep "invoker status changed"`" ]
do
    sleep 5
done

oc patch route openwhisk --namespace faas -p '{"spec":{"tls": {"insecureEdgeTerminationPolicy": "Allow"}}}'
