#!/bin/bash

# Setup AMQ on OpenShift
oc login -u system:admin
oc create -n openshift -f https://raw.githubusercontent.com/jboss-openshift/application-templates/ose-v1.4.5/jboss-image-streams.json
oc replace -n openshift -f https://raw.githubusercontent.com/jboss-openshift/application-templates/ose-v1.4.5/jboss-image-streams.json
oc -n openshift import-image jboss-amq-63

for template in amq62-basic.json \
 amq62-ssl.json \
 amq63-persistent-ssl.json \
 amq62-persistent.json \
 amq63-basic.json \
 amq63-ssl.json \
 amq62-persistent-ssl.json \
 amq63-persistent.json;
 do
 	oc replace -n openshift -f https://raw.githubusercontent.com/jboss-openshift/application-templates/ose-v1.4.5/amq/${template}
 done

