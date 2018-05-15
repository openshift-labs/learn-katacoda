# General Preparation
ssh root@host01 'git clone https://github.com/fatherlinux/container-internals-lab.git ~/labs'
ssh root@host01 '/var/lib/openshift/openshift admin policy add-cluster-role-to-user cluster-admin admin'

# Lab 1
ssh root@host01 'cp ~/labs/lab1-step3/mega-proc.sh /usr/bin/mega-proc.sh'

# Lab 2
ssh root@host01 'git clone --single-branch --branch centos7 https://github.com/fatherlinux/container-supply-chain.git ~/labs/lab2-step4/'

# Lab 3


# Lab 4
ssh root@host01 'git clone https://github.com/fatherlinux/container-supply-chain.git ~/labs/lab4-step4/'

# Final Preparation
ssh root@host01 'docker pull rhel7'
ssh root@host01 'docker pull rhel7-atomic'
ssh root@host01 'docker pull nate/dockviz'
