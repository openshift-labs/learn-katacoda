#!/bin/bash
cd projects/rhoar-getting-started/spring/spring-monitoring
~/.launch.sh

oc login [[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com --insecure-skip-tls-verify=true -u developer -p developer
oc new-project dev --display-name="Dev - Spring Boot App"
mvn package fabric8:deploy -Popenshift
