# General Preparation
ssh root@host01 'mkdir ~/labs'
ssh root@host01 'docker pull rhel7'
ssh root@host01 'docker pull rhel7-atomic'
ssh root@host01 'docker pull nate/dockviz'
ssh root@host01 '/var/lib/openshift/openshift admin policy add-cluster-role-to-user cluster-admin admin'

# Lab 1

ssh root@host01 'cp ~/intro-katacoda/subsystems/container-internals-lab-3/assets/exercise-01/mega-proc.sh /usr/bin/mega-proc.sh'

# Lab 4
ssh root@host01 'git clone https://github.com/fatherlinux/container-supply-chain.git ~/labs/e04/'
