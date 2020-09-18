#!/bin/bash

wget https://github.com/apache/camel-k/releases/download/v1.1.0/camel-k-client-1.1.0-linux-64bit.tar.gz
tar -xvf camel-k-client-1.1.0-linux-64bit.tar.gz
mv kamel /usr/bin

echo "test"
mkdir camel-api


oc apply -f https://raw.githubusercontent.com/weimeilin79/learn-katacoda/master/middleware/middleware-camelk/camel-k-eventing/assets/serverless/subscription.yaml

timeout 30 >nul

oc apply -f https://raw.githubusercontent.com/weimeilin79/learn-katacoda/master/middleware/middleware-camelk/camel-k-eventing/assets/serverless/serving.yaml
oc apply -f https://raw.githubusercontent.com/weimeilin79/learn-katacoda/master/middleware/middleware-camelk/camel-k-eventing/assets/serverless/eventing.yaml
