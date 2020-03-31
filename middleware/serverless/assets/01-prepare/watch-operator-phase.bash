#!/usr/bin/env bash

while : do
  echo "Checking..."
  phase=`oc get csv -n openshift-operators serverless-operator.v1.4.1 -o jsonpath='{.status.phase}'`
  if [ $phase == "Succeeded" ]; then echo "Installed"; break; fi
  sleep 10
done
