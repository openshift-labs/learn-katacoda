ssh root@host01 'for i in {1..200}; do oc policy add-role-to-user system:image-puller system:anonymous && break || sleep 1; done'
ssh root@host01 'oc adm policy add-cluster-role-to-group sudoer system:authenticated'
ssh root@host01 "mkdir -p /data/pv-01 /data/pv-02 /data/pv-03 /data/pv-04 /data/pv-05 /data/pv-06 /data/pv-07 /data/pv-08 /data/pv-09 /data/pv-10"
ssh root@host01 "chmod 0777 /data/pv-*"
ssh root@host01 "oc create -f volumes.json"
ssh root@host01 'for i in {1..200}; do oc get project/openshift && break || sleep 1; done'
ssh root@host01 "oc create -f https://github.com/openshift/origin/raw/release-3.6/examples/db-templates/mongodb-persistent-template.json -n openshift"
ssh root@host01 "oc create -f https://github.com/openshift/origin/raw/release-3.6/examples/db-templates/mongodb-ephemeral-template.json -n openshift"
ssh root@host01 "oc create -f https://github.com/openshift/origin/raw/release-3.6/examples/db-templates/mariadb-persistent-template.json -n openshift"
ssh root@host01 "oc create -f https://github.com/openshift/origin/raw/release-3.6/examples/db-templates/mariadb-ephemeral-template.json -n openshift"
ssh root@host01 "oc create -f https://github.com/openshift/origin/raw/release-3.6/examples/db-templates/mysql-persistent-template.json -n openshift"
ssh root@host01 "oc create -f https://github.com/openshift/origin/raw/release-3.6/examples/db-templates/mysql-ephemeral-template.json -n openshift"
ssh root@host01 "oc create -f https://github.com/openshift/origin/raw/release-3.6/examples/db-templates/postgresql-persistent-template.json -n openshift"
ssh root@host01 "oc create -f https://github.com/openshift/origin/raw/release-3.6/examples/db-templates/postgresql-ephemeral-template.json -n openshift"
ssh root@host01 "oc create -f https://github.com/openshift/origin/raw/release-3.6/examples/db-templates/redis-persistent-template.json -n openshift"
ssh root@host01 "oc create -f https://github.com/openshift/origin/raw/release-3.6/examples/db-templates/redis-ephemeral-template.json -n openshift"
ssh root@host01 "docker pull openshiftroadshow/parksmap-py:1.0.0"
ssh root@host01 "docker pull centos/python-35-centos7:latest"
