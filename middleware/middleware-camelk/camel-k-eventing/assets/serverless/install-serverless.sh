#!/bin/bash

oc login -u admin -p admin

sleep 10

oc apply -f https://raw.githubusercontent.com/weimeilin79/learn-katacoda/master/middleware/middleware-camelk/camel-k-eventing/assets/serverless/subscription.yaml


function wait_for_operator_install {
  local A=1
  local sub=$1
  while : ;
  do
  	sleep 10
    echo "$A: Checking..."
    phase=`oc get csv -n openshift-operators $sub -o jsonpath='{.status.phase}'`
    if [[ $phase == "Succeeded" ]]; then echo "$sub Installed"; break; fi
    A=$((A+1))
  done
}

SERVERLESS_OP_NAME=""

function install_operator {
  echo SERVERLESS_OP_NAME ${SERVERLESS_OP_NAME}
  
  while [ -z $SERVERLESS_OP_NAME ] ;
  do
  	sleep 10
  	ops=`oc get csv -n openshift-operators`
  	pat='(serverless-operator\S+)'
  	[[ $ops =~ $pat ]] # From this line
    SERVERLESS_OP_NAME=${BASH_REMATCH[0]}
    install_operator
  done
  
}

install_operator
wait_for_operator_install $SERVERLESS_OP_NAME





oc new-project knative-serving

sleep 10

oc apply -f https://raw.githubusercontent.com/weimeilin79/learn-katacoda/master/middleware/middleware-camelk/camel-k-eventing/assets/serverless/serving.yaml -n knative-serving

A=1
while : ;
do
  sleep 3
  output=`oc get knativeserving.operator.knative.dev/knative-serving -n knative-serving --template='{{range .status.conditions}}{{printf "%s=%s\n" .type .status}}{{end}}'`
  echo "$A: $output"
  if [ -z "${output##*'Ready=True'*}" ] ; then echo "Installed"; break; fi;
  A=$((A+1))
done


echo "Camel K Eventing Tutorial Ready!"