#!/usr/bin/env bash
set -o pipefail 

mkdir -p /root/projects && cd /root/projects/

git clone https://github.com/redhat-developer-demos/knative-tutorial

cd  knative-tutorial && rm -rf !("basics"|"scaling")

oc create -f https://raw.githubusercontent.com/btannous/learn-katacoda/serverless/middleware/serverless/assets/operator-subscription.yaml

sleep 10
source assets/approve-csv.bash
approve_csv 1.4.1

oc adm new-project knativetutorial
oc adm policy add-role-to-user admin developer -n knativetutorial
