#!/bin/bash

wget https://github.com/apache/camel-k/releases/download/v1.1.1/camel-k-client-1.1.1-linux-64bit.tar.gz
tar -xvf camel-k-client-1.1.1-linux-64bit.tar.gz
mv kamel /usr/bin

echo "test"
mkdir camel-eventing


oc apply -f https://raw.githubusercontent.com/weimeilin79/learn-katacoda/master/middleware/middleware-camelk/camel-k-eventing/assets/serverless/subscription.yaml

timeout 60 >nul

#oc apply -f https://raw.githubusercontent.com/weimeilin79/learn-katacoda/master/middleware/middleware-camelk/camel-k-eventing/assets/serverless/eventing.yaml
oc apply -f https://raw.githubusercontent.com/weimeilin79/learn-katacoda/master/middleware/middleware-camelk/camel-k-eventing/assets/serverless/serving.yaml

timeout 30 >nul

oc apply -f https://raw.githubusercontent.com/weimeilin79/learn-katacoda/master/middleware/middleware-camelk/camel-k-eventing/assets/serverless/serving.yaml

timeout 30 >nul

oc apply -f https://github.com/knative/eventing-contrib/releases/download/v0.16.1/camel.yaml