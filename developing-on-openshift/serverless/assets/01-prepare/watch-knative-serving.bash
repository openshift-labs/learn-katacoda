#!/usr/bin/env bash

A=1
while : ;
do
  output=`oc get knativeserving.operator.knative.dev/knative-serving -n knative-serving --template='{{range .status.conditions}}{{printf "%s=%s\n" .type .status}}{{end}}'`
  echo "$A: $output"
  if [ -z "${output##*'Ready=True'*}" ] ; then echo "Installed"; break; fi;
  A=$((A+1))
  sleep 10
done
