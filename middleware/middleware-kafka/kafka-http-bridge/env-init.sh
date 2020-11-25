#!/bin/bash

# Install operator
oc -n openshift-operators apply -f /opt/operator-install.yaml

# Grant permission to developer
oc apply -f /opt/strimzi-admin.yaml
oc adm policy add-cluster-role-to-user strimzi-admin developer

# Start Kafka
oc new-project kafka --as developer
oc -n kafka apply -f /opt/kafka-cluster.yaml
