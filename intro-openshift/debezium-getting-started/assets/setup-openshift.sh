#!/usr/bin/bash
DEBEZIUM_TAG=0.6

# Install templates
oc create -n openshift -f https://raw.githubusercontent.com/EnMasseProject/barnabas/master/kafka-statefulsets/resources/openshift-template.yaml
oc create -n openshift -f https://raw.githubusercontent.com/EnMasseProject/barnabas/master/kafka-connect/s2i/resources/openshift-template.yaml

# Persistent volumes
oc create -f https://raw.githubusercontent.com/EnMasseProject/barnabas/master/kafka-statefulsets/resources/cluster-volumes.yaml
for i in {1,2,3,4,5,6}; do
  PV=/tmp/pv000${i}
  mkdir -p $PV
  chmod 777 $PV
done

# Create project
oc login -u debezium -p debezium
oc new-project debezium

# Start pre-populated database
oc new-app --name=mysql debezium/example-mysql:${DEBEZIUM_TAG}
oc env dc/mysql MYSQL_ROOT_PASSWORD=debezium  MYSQL_USER=mysqluser MYSQL_PASSWORD=mysqlpw
