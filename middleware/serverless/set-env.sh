#!/bin/bash
git clone --depth 1 -b serverless https://github.com/btannous/learn-katacoda.git .learn-katacoda
sleep 1
ln -s .learn-katacoda/middleware/serverless serverless
cd serverless
#oc apply -f assets/operator-subscription.yaml
#source assets/approve-csv.bash
#sleep 10
#while [ -z $(find_install_plan 1.4.1) ]; do sleep 10; done
#approve_csv 1.4.1
#sleep 60
#oc apply -f assets/serving.yaml
#oc adm new-project serverless-tutorial
#oc adm policy add-role-to-user admin developer -n serverless-tutorial
#cd assets
clear; echo "Serverless Tutorial Ready!"
