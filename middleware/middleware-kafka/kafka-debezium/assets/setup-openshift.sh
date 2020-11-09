#!/usr/bin/bash
DEBEZIUM_TAG=0.10
STRIMZI_VERSION=0.14.0

# Get Strimzi
curl -kL https://github.com/strimzi/strimzi-kafka-operator/releases/download/$STRIMZI_VERSION/strimzi-$STRIMZI_VERSION.tar.gz | tar xz
cd strimzi-$STRIMZI_VERSION

# Create project
oc new-project debezium

# Install controller and templates
sed -i 's/namespace: .*/namespace: debezium/' install/cluster-operator/*RoleBinding*.yaml
kubectl apply -f install/cluster-operator -n debezium && oc create -f examples/templates/cluster-operator

# Start pre-populated database
oc new-app --name=mysql debezium/example-mysql:${DEBEZIUM_TAG}
oc set env dc/mysql MYSQL_ROOT_PASSWORD=debezium  MYSQL_USER=mysqluser MYSQL_PASSWORD=mysqlpw

cd ~/debezium
