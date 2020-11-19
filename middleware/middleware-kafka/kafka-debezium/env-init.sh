#!/usr/bin/env bash

# Install operator
oc -n openshift-operators apply -f /opt/operator-install.yaml

# Grant permission to developer
oc apply -f /opt/strimzi-admin.yaml
oc adm add-role-to-user strimzi-admin developer

# Start pre-populated database
oc new-app --name=mysql -e MYSQL_ROOT_PASSWORD=debezium -e MYSQL_USER=mysqluser -e MYSQL_PASSWORD=mysqlpw debezium/example-mysql:1.3
