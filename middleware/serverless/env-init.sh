#!/usr/bin/env bash
set -o pipefail 

oc create -f https://raw.githubusercontent.com/btannous/learn-katacoda/serverless/middleware/serverless/assets/operator-subscription.yaml
source assets/approve-csv.bash
while [ -z $(find_install_plan $csv_version) ] do sleep 10; done
approve_csv 1.4.1

mkdir -p /root/projects && cd /root/projects/

git clone https://github.com/redhat-developer-demos/knative-tutorial

cd  knative-tutorial && rm -rf !("basics"|"scaling")

oc adm new-project knativetutorial
oc adm policy add-role-to-user admin developer -n knativetutorial
