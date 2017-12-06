#!/bin/bash
~/.launch.sh

# Import the required ImageStreams and templates
oc create -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/jboss-image-streams.json -n openshift
oc create -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/decisionserver/decisionserver64-basic-s2i.json -n openshift

# Logging as Developer
oc login -u developer -p developer

echo '----------------------------------------------'
echo 'Katacoda BRMS Loan Application instance ready!'
echo '----------------------------------------------'
