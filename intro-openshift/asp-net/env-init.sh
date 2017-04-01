ssh root@host01 "docker pull centos/python-35-centos7:latest"
ssh root@host01 "docker pull openshiftroadshow/parksmap-katacoda:1.0.0"
ssh root@host01 'for i in {1..200}; do oc policy add-role-to-user system:image-puller system:anonymous && break || sleep 1; done'
