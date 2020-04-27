ssh root@host01 "mkdir -p /root/projects/quarkus"
ssh root@host01 "touch /etc/rhsm/ca/redhat-uep.pem"
ssh root@host01 "yum install -y openssl openssl-pkcs11 && yum upgrade -y openssl-libs"
ssh root@host01 "echo -w\ \"\n\" >> ~/.curlrc"