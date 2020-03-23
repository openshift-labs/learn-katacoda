#!/bin/bash

cd projects/knative-tutorial

sleep 151; while echo && oc get pods -n knative-serving | grep -v -E "(Running|Completed|STATUS)"; do sleep 20; done
