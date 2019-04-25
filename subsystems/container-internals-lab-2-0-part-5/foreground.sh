# General Preparation
ssh root@host01 'git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs'
ssh root@host01 'yum install -y podman buildah skopeo skopeo-containers tree httpd-tools strace &'
ssh root@host01 'cp ~/labs/lab1-step3/mega-proc.sh /usr/bin/mega-proc.sh'

# Lab 5
podman pull registry.access.redaht.com/ubi7/ubi
ssh root@host01 'git clone --depth 1 --single-branch --branch lab4-step1 https://github.com/fatherlinux/wordpress-demo.git ~/labs/lab4-step1'
ssh root@host01 '~/labs/lab4-step1/create.sh'
ssh root@host01 'sed -i s/wpfrontend-wordpress.apps.example.com/`hostname`/ ~/labs/lab4-step1/wordpress-objects.yaml'
