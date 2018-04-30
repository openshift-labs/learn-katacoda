#! /bin/bash

wget -N -nv https://github.com/apache/incubator-openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-linux-386.tgz \
    -O /tmp/OpenWhisk_CLI-latest-linux-386.tgz
sudo tar xzvf /tmp/OpenWhisk_CLI-latest-linux-386.tgz -C /usr/local/bin wsk

oc new-project faas --display-name="FaaS - Apache OpenWhisk"
until $(oc status &> /dev/null); do sleep 1; done;
oc adm policy add-cluster-role-to-user cluster-admin admin
oc adm policy add-role-to-user admin developer -n faas

oc process -f https://git.io/vpnUR | oc create -f -

oc patch route openwhisk --namespace faas -p '{"spec":{"tls": {"insecureEdgeTerminationPolicy": "Allow"}}}'

AUTH_SECRET=$(oc get secret whisk.auth -o yaml | grep "system:" | awk '{print $2}' | base64 --decode)
wsk property set --auth $AUTH_SECRET --apihost $(oc get route/openwhisk --template="{{.spec.host}}")


git clone https://github.com/apache/incubator-openwhisk-devtools openwhisk-devtools
cd openwhisk-devtools/java-action-archetype \
    && mvn -DskipTests clean install  \
    && cd  \
    && rm -rf /tmp/openwhisk-devtools

rm -rf /root/projects/
mkdir -p /root/projects/

echo "Waiting for Apache OpenWhisk environment to be ready. It can take from 2 to 3 minutes."
while $(oc get pods -n faas controller-0 | grep 0/1 > /dev/null); do sleep 1; done
