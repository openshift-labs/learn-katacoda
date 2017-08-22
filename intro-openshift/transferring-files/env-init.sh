ssh root@host01 "setenforce 0 || true"
ssh root@host01 "mkdir /tmp/pv-01 /tmp/pv-02"
ssh root@host01 "chmod 0777 /tmp/pv-01 /tmp/pv-02"
ssh root@host01 "oc create -f volumes.json"
ssh root@host01 "docker pull openshiftkatacoda/blog-django-py:latest"
ssh root@host01 "docker pull centos/httpd-24-centos7:latest"
ssh root@host01 'for i in {1..200}; do oc policy add-role-to-user system:image-puller system:anonymous && break || sleep 1; done'
