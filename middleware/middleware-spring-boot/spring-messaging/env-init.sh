ssh root@host01 "git --git-dir=/root/projects/rhoar-getting-started/.git --work-tree=/root/projects/rhoar-getting-started pull"
ssh root@host01 "yum install tree -y"
ssh root@host01 "mkdir /root/projects/rhoar-getting-started/spring/spring-messaging/amq"
ssh root@host01 "chmod 777 /root/projects/rhoar-getting-started/spring/spring-messaging/amq"

ssh root@host01 "mkdir -p /root/code/amq"
ssh root@host01 "chcon -R -t svirt_sandbox_file_t /root/code/amq"
ssh root@host01 "restorecon -R /root/code/amq"
ssh root@host01 "chmod 777 /root/code/amq"

ssh root@host01 "touch /etc/rhsm/ca/redhat-uep.pem"
