# General Preparation
ssh root@host01 'git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs'
ssh root@host01 'yum install -y podman buildah skopeo skopeo-containers tree httpd-tools strace &'

# Lab 1
podman pull registry.access.redhat.com/ubi7/ubi
podman pull registry.access.redhat.com/ubi7/ubi-minimal
