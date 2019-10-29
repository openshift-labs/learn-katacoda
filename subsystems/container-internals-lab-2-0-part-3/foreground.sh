# General Preparation
git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
yum install -y podman buildah skopeo skopeo-containers tree httpd-tools strace
yum install -y https://cbs.centos.org/kojifiles/packages/podman/1.5.1/3.el7/noarch/podman-manpages-1.5.1-3.el7.noarch.rpm \
https://cbs.centos.org/kojifiles/packages/podman/1.5.1/3.el7/x86_64/podman-1.5.1-3.el7.x86_64.rpm \
https://cbs.centos.org/kojifiles/packages/slirp4netns/0.3.0/2.git4992082.el7/x86_64/slirp4netns-0.3.0-2.git4992082.el7.x86_64.rpm \
https://cbs.centos.org/kojifiles/packages/libseccomp/2.4.1/0.el7/x86_64/libseccomp-2.4.1-0.el7.x86_64.rpm
cp -f ~/labs/lab1-step3/mega-proc.sh /usr/bin/mega-proc.sh

# Lab 3
podman pull registry.access.redhat.com/ubi7/ubi
podman pull registry.access.redhat.com/ubi7/ubi:7.6-73
podman pull registry.fedoraproject.org/fedora
podman pull docker.io/centos:7.0.1406
podman pull docker.io/ubuntu:trusty-20170330

echo "Container host is now ready."
