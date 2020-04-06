#!/usr/bin/env bash
while : ;
do
  output=`oc get pod -n knative-serving`
  echo $output
  if [ -z "${output##*'Running'*}" ] ; then echo "Service is ready."; break; fi;
  sleep 5
done
