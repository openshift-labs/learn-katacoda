#!/bin/bash

wget https://github.com/apache/camel-k/releases/download/1.0.0-nightly.202005130003/camel-k-client-1.0.0-nightly.202005130003-linux-64bit.tar.gz
tar -xvf camel-k-client-1.0.0-nightly.202005130003-linux-64bit.tar.gz
mv kamel /usr/bin

echo "test1"
mkdir camel-api
