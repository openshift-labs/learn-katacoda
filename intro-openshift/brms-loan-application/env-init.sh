#!/bin/bash
/usr/local/bin/oc create -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/jboss-image-streams.json -n openshift
/usr/local/bin/oc create -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/decisionserver/decisionserver64-basic-s2i.json -n openshift

/usr/local/bin/oc login -u developer -p developer
