#!/bin/bash
oc create -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/jboss-image-streams.json -n openshift
oc create -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/decisionserver/decisionserver64-basic-s2i.json -n openshift

oc login -u developer -p developer
