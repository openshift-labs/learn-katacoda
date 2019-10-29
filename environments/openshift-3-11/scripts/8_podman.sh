echo "**** Configuring Podman etc ****"

yum install -y http://assets.joinscrapbook.com/redhat/packages/podman-1.3.2-1.git14fdcd0.el7.centos.x86_64.rpm
yum install -y buildah skopeo skopeo-containers tree httpd-tools strace

podman pull registry.access.redhat.com/ubi7/ubi
podman pull registry.access.redhat.com/ubi7/ubi-minimal
podman pull registry.access.redhat.com/ubi7/ubi:7.6-73
podman pull rhel7
podman pull fedora
podman pull centos
podman pull registry.fedoraproject.org/fedora
podman pull docker.io/centos:7.0.1406
podman pull docker.io/ubuntu:trusty-20170330
podman pull quay.io/fatherlinux/linux-container-internals-2-0-introduction
skopeo copy containers-storage:registry.access.redhat.com/ubi7/ubi:latest docker-daemon:registry.access.redhat.com/ubi7/ubi:latest
skopeo copy containers-storage:quay.io/fatherlinux/linux-container-internals-2-0-introduction:latest docker-daemon:quay.io/fatherlinux/linux-container-internals-2-0-introduction:latest
