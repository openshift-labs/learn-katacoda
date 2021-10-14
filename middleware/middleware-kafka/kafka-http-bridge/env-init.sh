#!/bin/bash

# Install operator
oc -n openshift-operators apply -f /opt/operator-install.yaml

# Start Kafka
oc new-project kafka

# Check if Operator is installed
echo -e "Waiting for CRDs... (This might take a couple minutes)"

while : ;
do
  output=`oc get crds kafkas.kafka.strimzi.io --ignore-not-found`
  echo "$output"
  if [ -n "$output" ] ; then echo "CRD is ready."; break; fi;
  sleep 5
done

oc wait crd/kafkas.kafka.strimzi.io --for=condition=Established --timeout=600s

# Deploy cluster
oc -n kafka apply -f /opt/kafka-cluster.yaml

# Grant permission to developer
oc apply -f /opt/strimzi-admin.yaml

oc adm policy add-cluster-role-to-user strimzi-admin developer

oc adm policy add-role-to-user admin developer -n kafka
