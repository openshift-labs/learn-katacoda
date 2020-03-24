#!/bin/bash
git clone --depth 1 -b serverless https://github.com/btannous/learn-katacoda.git .learn-katacoda
ln -s serverless .learn-katacoda/middleware/serverless
cd serverless
oc create -f assets/operator-subscription.yaml
source assets/approve-csv.bash
sleep 5
while [ -z $(find_install_plan 1.4.1) ]; do sleep 10; done
approve_csv 1.4.1

oc adm new-project serverless-tutorial
oc adm policy add-role-to-user admin developer -n serverless-tutorial

sleep 5; while echo && oc get pods -n knative-serving | grep -v -E "(Running|Completed|STATUS)"; do sleep 20; done
