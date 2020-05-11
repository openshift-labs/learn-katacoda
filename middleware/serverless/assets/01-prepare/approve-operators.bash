#!/usr/bin/env bash
OPERATORS_NAMESPACE='openshift-operators'
OPERATOR='redhat-operators'

function approve_csv {
  local csv_version install_plan
  csv_version=$1

  install_plan=$(find_install_plan $csv_version)
  oc get $install_plan -n ${OPERATORS_NAMESPACE} -o yaml | sed 's/\(.*approved:\) false/\1 true/' | oc replace -f -
}

function find_install_plan {
  local csv=$1
  for plan in `oc get installplan -n ${OPERATORS_NAMESPACE} --no-headers -o name`; do
    [[ $(oc get $plan -n ${OPERATORS_NAMESPACE} -o=jsonpath='{.spec.clusterServiceVersionNames}' | grep -c $csv) -eq 1 && \
       $(oc get $plan -n ${OPERATORS_NAMESPACE} -o=jsonpath="{.status.catalogSources}" | grep -c $OPERATOR) -eq 1 ]] && echo $plan && return 0
  done
  echo ""
}

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

while [ -z $(find_install_plan 1.1.0) ]; do sleep 10; echo "Checking for service mesh CSV..."; done
approve_csv 1.1.0
sleep 5
wait_for_operator_install servicemeshoperator.v1.1.0

while [ -z $(find_install_plan 1.4.1) ]; do sleep 10; echo "Checking for serverless CSV..."; done
approve_csv 1.4.1
sleep 5
wait_for_operator_install serverless-operator.v1.4.1
