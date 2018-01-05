ssh root@host01 "yum install -y postgresql socat"
ssh root@host01 'for i in {1..200}; do oc policy add-role-to-user system:image-puller system:anonymous && break || sleep 1; done'
ssh root@host01 "docker pull centos/postgresql-95-centos7:latest"
ssh root@host01 'for i in {1..200}; do oc get project/openshift && break || sleep 1; done'
ssh root@host01 "oc create -f https://raw.githubusercontent.com/openshift/origin/master/examples/db-templates/postgresql-ephemeral-template.json -n openshift"
