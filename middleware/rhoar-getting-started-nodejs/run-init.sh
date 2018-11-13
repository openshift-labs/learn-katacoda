ssh root@host01 "curl -k --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -"
ssh root@host01 "yum -y install nodejs npm"
ssh root@host01 "touch /etc/rhsm/ca/redhat-uep.pem"
