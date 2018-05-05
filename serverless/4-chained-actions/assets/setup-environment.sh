#!/bin/bash

echo "Waiting for Apache OpenWhisk environment to be ready. It can take from 2 to 3 minutes."

export PATH=/root/:${PATH}
rm -rf /root/projects/*
mkdir -p /root/projects
rm -rf /root/temp-pom.xml

oc new-project faas --display-name='FaaS - OpenShift Cloud Functions' 1> /dev/null

wget -q -N -nv https://github.com/projectodd/openwhisk-openshift/releases/download/latest/OpenWhisk_CLI-latest-linux-386.tgz \
    -O /tmp/OpenWhisk_CLI-latest-linux-386.tgz
sudo tar xzf /tmp/OpenWhisk_CLI-latest-linux-386.tgz -C /usr/local/bin wsk

until $(oc status &> /dev/null); do sleep 1; done;
oc adm policy add-cluster-role-to-user cluster-admin admin 1> /dev/null
oc adm policy add-role-to-user admin developer -n faas 1> /dev/null
oc process -f https://git.io/vpnUR | oc create -f - 1> /dev/null

git clone -q https://github.com/apache/incubator-openwhisk-devtools /tmp/openwhisk-devtools
mvn -q -f /tmp/openwhisk-devtools/java-action-archetype -DskipTests install

while $(oc get pods -n faas controller-0 | grep 0/1 > /dev/null); do sleep 1; done

oc patch route openwhisk --namespace faas -p '{"spec":{"tls": {"insecureEdgeTerminationPolicy": "Allow"}}}'  1> /dev/null

AUTH_SECRET=$(oc get secret whisk.auth -o yaml | grep "system:" | awk '{print $2}' | base64 --decode) 1> /dev/null
wsk property set --auth $AUTH_SECRET --apihost $(oc get route/openwhisk --template="{{.spec.host}}") 1> /dev/null
