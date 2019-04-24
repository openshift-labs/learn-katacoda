# General Preparation
ssh root@host01 'git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs'
ssh root@host01 'yum install -y podman buildah skopeo skopeo-containers tree httpd-tools strace &'

# Lab 4
ssh root@host01 'cp ~/labs/lab3-step1/atomic-openshift-master.service /etc/systemd/system/atomic-openshift-master.service'
ssh root@host01 'cp ~/labs/lab3-step1/atomic-openshift-node.service /etc/systemd/system/atomic-openshift-node.service'
ssh root@host01 'systemctl disable --now origin.service'
ssh root@host01 'systemctl enable --now atomic-openshift-master.service; systemctl enable --now atomic-openshift-node.service'

# Final Preparation
ssh root@host01 'docker pull rhel7'
ssh root@host01 'docker pull rhel7-atomic'
ssh root@host01 'docker pull nate/dockviz'
ssh root@host01 'docker pull centos'
ssh root@host01 'docker pull fedora'
ssh root@host01 'docker pull ubuntu'
ssh root@host01 'docker pull openshift3/mysql-55-rhel7'
ssh root@host01 'podman pull rhel7'
ssh root@host01 'podman pull centos'
ssh root@host01 'podman pull fedora'
ssh root@host01 '/var/lib/openshift/openshift admin policy add-cluster-role-to-user cluster-admin admin'
