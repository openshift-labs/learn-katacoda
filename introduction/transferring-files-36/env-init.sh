ssh root@host01 "docker pull openshiftkatacoda/blog-django-py:latest"
ssh root@host01 "docker pull centos/httpd-24-centos7:latest"
ssh root@host01 'for i in {1..200}; do oc policy add-role-to-user system:image-puller system:anonymous && break || sleep 1; done'
ssh root@host01 "mkdir -p /data/pv-01 /data/pv-02"
ssh root@host01 "chmod 0777 /data/pv-01 /data/pv-02"
ssh root@host01 "oc create -f volumes.json"
