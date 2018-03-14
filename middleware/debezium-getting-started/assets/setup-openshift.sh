#!/usr/bin/bash
DEBEZIUM_TAG=0.7
STRIMZI_VERSION=0.2.0

# Get Strimzi
git clone -b $STRIMZI_VERSION https://github.com/strimzi/strimzi
cd strimzi

# Create project
oc new-project debezium

# Install controller and templates
oc create -f examples/install/cluster-controller && oc create -f examples/templates/cluster-controller

# Start pre-populated database
oc new-app --name=mysql debezium/example-mysql:${DEBEZIUM_TAG}
oc env dc/mysql MYSQL_ROOT_PASSWORD=debezium  MYSQL_USER=mysqluser MYSQL_PASSWORD=mysqlpw

cd ~/debezium
