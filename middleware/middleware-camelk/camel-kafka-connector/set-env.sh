#!/bin/bash
while [ ! -f strimzi/streams-operator.yaml ]
do
	sleep 5
done

oc new-project camel-kafka
oc create -f strimzi/streams-operator.yaml