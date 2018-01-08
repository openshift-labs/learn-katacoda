ssh root@host01 'for i in {1..200}; do oc policy add-role-to-user system:image-puller system:anonymous && break || sleep 1; done'
ssh root@host01 'oc adm policy add-cluster-role-to-group sudoer system:authenticated'
ssh root@host01 'for i in {1..200}; do oc get project/openshift --as system:admin && break || sleep 1; done'
ssh root@host01 "oc create -f https://github.com/openshift/origin/raw/release-3.6/examples/db-templates/postgresql-ephemeral-template.json -n openshift"
ssh root@host01 "yum install -y postgresql socat"
ssh root@host01 "docker pull centos/postgresql-95-centos7:latest"
