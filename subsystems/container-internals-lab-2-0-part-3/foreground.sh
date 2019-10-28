# General Preparation
git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
yum install -y yum-plugin-versionlock
yum versionlock podman-1.3.2
yum remove -y podman
yum install -y podman buildah skopeo skopeo-containers tree httpd-tools strace
cp -f ~/labs/lab1-step3/mega-proc.sh /usr/bin/mega-proc.sh

# Lab 3
podman pull registry.access.redhat.com/ubi7/ubi
podman pull registry.access.redhat.com/ubi7/ubi:7.6-73
podman pull registry.fedoraproject.org/fedora
podman pull docker.io/centos:7.0.1406
podman pull docker.io/ubuntu:trusty-20170330

echo "Container host is now ready."
