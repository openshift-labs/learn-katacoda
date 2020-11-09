#!/usr/bin/env bash

# Pull images
STRIMZI_VERSION=0.14.0
KAFKA_VERSION=2.3.0
DEBEZIUM_VERSION=0.10
ssh root@host01 "docker pull debezium/example-mysql:$DEBEZIUM_VERSION; docker pull strimzi/operator:$STRIMZI_VERSION; docker pull strimzi/kafka:$STRIMZI_VERSION-kafka-$KAFKA_VERSION"
