# General Preparation
git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs

yum remove -y podman
yum install -y http://assets.joinscrapbook.com/redhat/packages/podman-1.3.2-1.git14fdcd0.el7.centos.x86_64.rpm
yum install -y buildah skopeo skopeo-containers tree httpd-tools strace

# Lab 2
podman pull registry.access.redhat.com/ubi7/ubi
podman pull registry.access.redhat.com/ubi7/ubi-minimal

echo "Container host is now ready."
