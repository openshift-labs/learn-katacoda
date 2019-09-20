# General Preparation
git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs

yum remove -y podman
yum install -y http://assets.joinscrapbook.com/redhat/packages/podman-1.3.2-1.git14fdcd0.el7.centos.x86_64.rpm
yum install -y buildah skopeo skopeo-containers tree httpd-tools strace

cp -f ~/labs/lab1-step3/mega-proc.sh /usr/bin/mega-proc.sh

# Lab 5
podman pull registry.access.redhat.com/ubi7/ubi
git clone --depth 1 --single-branch --branch lab4-step1 https://github.com/fatherlinux/wordpress-demo.git ~/labs/lab4-step1
~/labs/lab4-step1/create.sh
sed -i s/wpfrontend-wordpress.apps.example.com/`hostname`/ ~/labs/lab4-step1/wordpress-objects.yaml
git clone --depth 1 --single-branch --branch centos7 https://github.com/fatherlinux/container-supply-chain.git ~/labs/lab2-step4/
