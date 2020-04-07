#!/usr/bin/env bash
A=1
while : ;
do
  echo "$A: Checking..."
  phase=`oc get csv -n openshift-operators serverless-operator.v1.4.1 -o jsonpath='{.status.phase}'`
  if [ $phase == "Succeeded" ]; then echo "Installed"; break; fi
  A=$((A+1))
  sleep 10
done
