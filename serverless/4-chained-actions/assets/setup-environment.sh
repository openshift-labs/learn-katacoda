#!/bin/bash

export PATH=/root/:${PATH}
rm -rf /root/projects/*
mkdir -p /root/projects
rm -rf /root/temp-pom.xml

while $(oc get pods -n faas controller-0 | grep 0/1 > /dev/null); do sleep 1; done

AUTH_SECRET=$(oc get secret whisk.auth -o yaml | grep "system:" | awk '{print $2}' | base64 --decode) 1> /dev/null
wsk property set --auth $AUTH_SECRET --apihost $(oc get route/openwhisk --template="{{.spec.host}}") 1> /dev/null

clear
echo Apache OpenWhisk is ready!
