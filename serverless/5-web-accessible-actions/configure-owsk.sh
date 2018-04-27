#! /bin/bash

rm -rf /root/projects/
mkdir -p /root/projects/


cd /tmp
if [ ! -f /usr/local/bin/wsk ]
then
    [ -f OpenWhisk_CLI-latest-linux-386.tgz ] || \
        wget -N -nv https://github.com/apache/incubator-openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-linux-386.tgz
    sudo tar xzvf OpenWhisk_CLI-latest-linux-386.tgz -C /usr/local/bin wsk
fi



until $(oc status &> /dev/null); do sleep 1; done; oc adm policy add-cluster-role-to-user cluster-admin admin
oc new-project faas --display-name="FaaS - Apache OpenWhisk"
oc adm policy add-role-to-user admin developer -n faas


oc process -f https://git.io/openwhisk-template | oc create -f -



git clone https://github.com/apache/incubator-openwhisk-devtools openwhisk-devtools
cd openwhisk-devtools/java-action-archetype \
    && mvn -DskipTests clean install  \
    && cd  \
    && rm -rf /tmp/openwhisk-devtools


echo "Waiting for OpenWhisk to finish initializing (`date '+%H:%M:%S'`)"
while [ -z "`oc logs controller-0 -n faas 2>&1 | grep "invoker status changed"`" ]
do
    sleep 5
done


oc patch route openwhisk --namespace faas -p '{"spec":{"tls": {"insecureEdgeTerminationPolicy": "Allow"}}}'


AUTH_SECRET=$(oc get secret whisk.auth -o yaml | grep "system:" | awk '{print $2}' | base64 --decode)
wsk property set --auth $AUTH_SECRET --apihost $(oc get route/openwhisk --template="{{.spec.host}}")
