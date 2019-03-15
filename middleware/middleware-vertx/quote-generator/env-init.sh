#!/bin/bash
# Standard environment initialization script. Assumes the installation path (the cp portion) has been
# created by Katacoda via a environment.uieditorpath key. (ex: "uieditorpath": "/root/code/spring-mvc")
touch /etc/rhsm/ca/redhat-uep.pem
touch /etc/docker/certs.d/registry.access.redhat.com/redhat-ca.crt

UI_PATH=/root/code

git clone -q https://github.com/openshift-katacoda/rhoar-getting-started
cd ${UI_PATH} && cp -R /root/rhoar-getting-started/vertx/vertx-microtrader/* .

clear # To clean up Katacoda terminal noise
~/.launch.sh