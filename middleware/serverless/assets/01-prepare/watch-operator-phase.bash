#!/usr/bin/env bash
# Find me in `.assets/01-prepare/watch-opeator-phase.bash`
phase=""

function check_for_operator_install {
  phase=`oc get csv -n openshift-operators serverless-operator.v1.4.1 -o jsonpath='{.status.phase}'`
}

while [ $phase != "Succeeded" ]; do
  sleep 10
  check_for_operator_install
done
