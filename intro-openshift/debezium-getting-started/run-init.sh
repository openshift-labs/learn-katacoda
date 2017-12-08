#!/usr/bin/env bash

# Pull images
ssh root@host01 "docker pull enmasseproject/zookeeper:latest; docker pull enmasseproject/kafka-statefulsets:latest; docker pull enmasseproject/kafka-connect-s2i:latest"
