ssh root@host01 "mkdir -p /root/projects/quarkus"
ssh root@host01 "touch /etc/rhsm/ca/redhat-uep.pem"
ssh root@host01 "yum -y install openssl openssl-devel"
ssh root@host01 "echo -w\ \"\n\" >> ~/.curlrc"