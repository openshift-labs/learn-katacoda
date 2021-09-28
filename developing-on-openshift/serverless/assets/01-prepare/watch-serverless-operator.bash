#!/usr/bin/env bash

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