ssh root@host01 'for i in {1..200}; do oc policy add-role-to-user system:image-puller system:anonymous && break || sleep 1; done'
ssh root@host01 "mkdir -p /data/pv-01 /data/pv-02 /data/pv-03 /data/pv-04 /data/pv-05 /data/pv-06 /data/pv-07 /data/pv-08 /data/pv-09 /data/pv-10"
ssh root@host01 "chmod 0777 /data/pv-*"
ssh root@host01 "oc create -f volumes.json"
ssh root@host01 'for i in {1..200}; do oc get project/openshift && break || sleep 1; done'
ssh root@host01 "oc create -f https://github.com/openshift/origin/raw/release-3.6/examples/db-templates/postgresql-persistent-template.json -n openshift"
