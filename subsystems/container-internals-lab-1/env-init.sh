ssh root@host01 'git clone https://github.com/fatherlinux/intro-katacoda.git'
ssh root@host01 'ln -s ~/intro-katacoda/subsystems/container-internals-lab-2/assets ~/assets'
ssh root@host01 'git clone https://github.com/fatherlinux/container-supply-chain.git ~/assets/exercise-04/'
ssh root@host01 '/var/lib/openshift/openshift admin policy add-cluster-role-to-user cluster-admin admin'
ssh root@host01 'cp ~/intro-katacoda/subsystems/container-internals-lab-3/assets/exercise-01/mega-proc.sh /usr/bin/mega-proc.sh'
ssh root@host01 'docker pull rhel7'
ssh root@host01 'docker pull rhel7-atomic'
ssh root@host01 'docker pull nate/dockviz'

