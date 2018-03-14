#!/usr/bin/env bash

# Pull images
STRIMZI_VERSION=0.2
DEBEZIUM_VERSION=0.7
ssh root@host01 "docker pull strimzi/zookeeper:$STRIMZI_VERSION; docker pull strimzi/kafka-statefulsets:$STRIMZI_VERSION; docker pull strimzi/kafka-connect-s2i:$STRIMZI_VERSION; docker pull strimzi/cluster-controller:$STRIMZI_VERSION; docker pull strimzi/topic-controller:$STRIMZI_VERSION docker pull debezium/example-mysql:$DEBEZIUM_VERSION"
