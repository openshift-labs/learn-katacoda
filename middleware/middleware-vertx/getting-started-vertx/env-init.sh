ssh root@host01 "git --git-dir=/root/projects/rhoar-getting-started/.git --work-tree=/root/projects/rhoar-getting-started pull"
ssh root@host01 "yum install tree -y"
ssh root@host01 "touch /etc/rhsm/ca/redhat-uep.pem"
