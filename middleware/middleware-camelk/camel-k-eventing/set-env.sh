#!/bin/bash

function wait_for_operator_install {
  local A=1
  local sub=$1
  while : ;
  do
    echo "$A: Checking..."
    phase=`oc get csv -n openshift-operators $sub -o jsonpath='{.status.phase}'`
    if [[ $phase == "Succeeded" ]]; then echo "$sub Installed"; break; fi
    A=$((A+1))
    sleep 10
  done
}



wget https://github.com/apache/camel-k/releases/download/v1.1.1/camel-k-client-1.1.1-linux-64bit.tar.gz
tar -xvf camel-k-client-1.1.1-linux-64bit.tar.gz
mv kamel /usr/bin


oc apply -f https://raw.githubusercontent.com/weimeilin79/learn-katacoda/master/middleware/middleware-camelk/camel-k-eventing/assets/serverless/subscription.yaml


# Get serverless-operator.v.X.X... name
# Will be stored in "${BASH_REMATCH[0]}"
ops=`oc get csv -n openshift-operators`
pat='(serverless-operator\S+)'
[[ $ops =~ $pat ]] # From this line

wait_for_operator_install ${BASH_REMATCH[0]}



oc new-project knative-serving

sleep 10

oc apply -f https://raw.githubusercontent.com/weimeilin79/learn-katacoda/master/middleware/middleware-camelk/camel-k-eventing/assets/serverless/serving.yaml -n knative-serving

A=1
while : ;
do
  output=`oc get knativeserving.operator.knative.dev/knative-serving -n knative-serving --template='{{range .status.conditions}}{{printf "%s=%s\n" .type .status}}{{end}}'`
  echo "$A: $output"
  if [ -z "${output##*'Ready=True'*}" ] ; then echo "Installed"; break; fi;
  A=$((A+1))
  sleep 10
done



echo "Camel K Eventing Tutorial Ready!"