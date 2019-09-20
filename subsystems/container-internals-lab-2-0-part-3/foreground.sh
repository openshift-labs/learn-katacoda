# General Preparation
git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs

yum remove -y podman
yum install -y http://assets.joinscrapbook.com/redhat/packages/podman-1.3.2-1.git14fdcd0.el7.centos.x86_64.rpm
yum install -y buildah skopeo skopeo-containers tree httpd-tools strace

# Lab 3
podman pull registry.access.redhat.com/ubi7/ubi
podman pull registry.access.redhat.com/ubi7/ubi:7.6-73
podman pull registry.fedoraproject.org/fedora
podman pull docker.io/centos:7.0.1406
podman pull docker.io/ubuntu:trusty-20170330

echo "Container host is now ready."
