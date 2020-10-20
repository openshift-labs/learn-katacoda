#!/bin/bash
while [ ! -f strimzi/operator-group.yaml ]
do
	sleep 5
done

oc new-project camel-kafka

oc create -f strimzi/operator-group.yaml

while [ ! -f strimzi/streams-operator.yaml ]
do
        sleep 5
done

oc create -f strimzi/streams-operator.yaml
