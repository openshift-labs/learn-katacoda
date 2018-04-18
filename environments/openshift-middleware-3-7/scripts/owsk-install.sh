#!/usr/bin/env bash

cd /tmp
[ -f OpenWhisk_CLI-latest-linux-386.tgz ] || \
    wget -N -nv https://github.com/apache/incubator-openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-linux-386.tgz
[ -f /usr/local/bin/wsk ] || sudo tar xzvf OpenWhisk_CLI-latest-linux-386.tgz -C /usr/local/bin wsk

until $(oc status &> /dev/null); do sleep 1; done; oc adm policy add-cluster-role-to-user cluster-admin admin
oc new-project faas --display-name="FaaS - Apache OpenWhisk"
oc adm policy add-role-to-user admin developer -n faas

oc process -f https://git.io/openwhisk-template | oc create -f -
#oc process -f https://github.com/projectodd/openwhisk-openshift/master/learn-template.yml | oc create -f -

git clone https://github.com/apache/incubator-openwhisk-devtools /tmp/openwhisk-devtools

cd /tmp/openwhisk-devtools/java-action-archetype \
    && mvn -DskipTests clean install  \
    && cd  \
    && rm -rf /tmp/openwhisk-devtools

while [ -z "`oc logs controller-0 -n faas 2>&1 | grep "invoker status changed"`" ]
do
    echo "Waiting for OpenWhisk to finish initializing (`date`)"
    sleep 10
done

oc patch route openwhisk --namespace faas -p '{"spec":{"tls": {"insecureEdgeTerminationPolicy": "Allow"}}}'