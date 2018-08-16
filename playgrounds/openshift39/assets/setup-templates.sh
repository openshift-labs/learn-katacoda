#!/bin/bash

{
set -x

    oc create -f https://github.com/openshift/origin/raw/release-3.9/examples/db-templates/mariadb-ephemeral-template.json -n openshift
    oc create -f https://github.com/openshift/origin/raw/release-3.9/examples/db-templates/mariadb-persistent-template.json -n openshift
    oc create -f https://github.com/openshift/origin/raw/release-3.9/examples/db-templates/mongodb-ephemeral-template.json -n openshift
    oc create -f https://github.com/openshift/origin/raw/release-3.9/examples/db-templates/mongodb-persistent-template.json -n openshift
    oc create -f https://github.com/openshift/origin/raw/release-3.9/examples/db-templates/mysql-ephemeral-template.json -n openshift
    oc create -f https://github.com/openshift/origin/raw/release-3.9/examples/db-templates/mysql-persistent-template.json -n openshift
    oc create -f https://github.com/openshift/origin/raw/release-3.9/examples/db-templates/postgresql-ephemeral-template.json -n openshift
    oc create -f https://github.com/openshift/origin/raw/release-3.9/examples/db-templates/postgresql-persistent-template.json -n openshift
    oc create -f https://github.com/openshift/origin/raw/release-3.9/examples/db-templates/redis-ephemeral-template.json -n openshift
    oc create -f https://github.com/openshift/origin/raw/release-3.9/examples/db-templates/redis-persistent-template.json -n openshift

} > /tmp/setup-templates.log 2>&1
