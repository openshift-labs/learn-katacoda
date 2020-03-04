#!/bin/bash
set -o pipefail 

mkdir -p /root/projects && cd /root/projects/

git clone https://github.com/redhat-developer-demos/knative-tutorial

cd  knative-tutorial && rm -rf !("basics"|"scaling")

oc create -f https://raw.githubusercontent.com/redhat-developer-demos/guru-night/master/config/redhat-operators-csc.yaml

sleep 30

! oc adm new-project knative-serving

oc create -f https://raw.githubusercontent.com/redhat-developer-demos/guru-night/master/config/knative-serving/subscription.yaml 

sleep 60

oc create -f https://raw.githubusercontent.com/redhat-developer-demos/guru-night/master/config/knative-serving/cr.yaml 

sleep 30

oc adm new-project knativetutorial
oc adm policy add-role-to-user admin developer -n knativetutorial

