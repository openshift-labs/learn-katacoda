#!/bin/bash

wget https://github.com/apache/camel-k/releases/download/v1.1.0/camel-k-client-1.1.0-linux-64bit.tar.gz
tar -xvf camel-k-client-1.1.0-linux-64bit.tar.gz
mv kamel /usr/bin

echo "test"
mkdir camel-api


oc apply -f serverless/subscription.yaml
oc apply -f serverless/serving.yaml
