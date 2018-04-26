#!/bin/bash

t1=$(date '+%s')

rm -rf /root/projects
export OPENWHISK_HOME="${HOME}/openwhisk"
mkdir -p $OPENWHISK_HOME/bin
mkdir -p /root/projects/ocf

wget https://github.com/apache/incubator-openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-linux-386.tgz
tar -zxf OpenWhisk_CLI-latest-linux-386.tgz -C $OPENWHISK_HOME/bin

export PATH="${OPENWHISK_HOME}/bin:${PATH}"

oc new-project faas --display-name="FaaS- OpenShift Cloud Functions"
oc adm policy add-role-to-user admin developer -n faas
oc process -f https://git.io/vpnUR | oc create -f -

PASSED=false
TIMEOUT=0
until $PASSED || [ $TIMEOUT -eq 60 ]; do
  OC_DEPLOY_STATUS=$(oc get pods -o wide | grep "controller-0" | awk '{print $3}')
  if [ "$OC_DEPLOY_STATUS" == "Running" ]; then
    PASSED=true
    break
  fi
  let TIMEOUT=TIMEOUT+1
  sleep 3
done

t2=$(date '+%s')
echo $((t2 - t1))

PASSED=false
TIMEOUT=0
until $PASSED || [ $TIMEOUT -eq 90 ]; do
  INVOKER_HEALTH=$(oc logs controller-0 -n faas | grep "invoker status changed" | grep " Healthy" | awk '{print $11}')
  if [ "$INVOKER_HEALTH" == "Healthy" ]; then
    PASSED=true
    break
  fi
  let TIMEOUT=TIMEOUT+1
  sleep 2
done

t3=$(date '+%s')
echo $((t3 - t1))

oc patch route openwhisk --namespace faas -p '{"spec":{"tls": {"insecureEdgeTerminationPolicy": "Allow"}}}'
AUTH_SECRET=$(oc get secret whisk.auth -o yaml | grep "system:" | awk '{print $2}' | base64 --decode)
wsk property set --auth $AUTH_SECRET --apihost $(oc get route/openwhisk --template="{{.spec.host}}")
wsk -i property get
wsk -i action list
