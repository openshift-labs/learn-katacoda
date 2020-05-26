#!/usr/bin/env bash

function wait_for_operator_install {
  local A=1
  local sub=$1
  while : ;
  do
    echo "$A: Checking..."
    phase=`oc get csv -n openshift-operators $sub -o jsonpath='{.status.phase}'`
    if [ $phase == "Succeeded" ]; then echo "$sub Installed"; break; fi
    A=$((A+1))
    sleep 10
  done
}

wait_for_operator_install $1
