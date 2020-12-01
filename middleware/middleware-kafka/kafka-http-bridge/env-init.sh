#!/bin/bash

# Install operator
oc -n openshift-operators apply -f /opt/operator-install.yaml

# Start Kafka
oc new-project kafka

# Check if operator is installed
echo -e "Waiting for CRDs... (This might take a couple minutes)"
until [ "$(oc get crds kafkas.kafka.strimzi.io --ignore-not-found | wc -l &)" = "2" ];
do
  sleep 2
done

# Deploy cluster
oc -n kafka apply -f /opt/kafka-cluster.yaml

# Grant permission to developer
oc apply -f /opt/strimzi-admin.yaml

oc adm policy add-cluster-role-to-user strimzi-admin developer

oc adm policy add-role-to-user admin developer -n kafka
