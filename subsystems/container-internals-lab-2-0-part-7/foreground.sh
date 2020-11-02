# General Preparation
git clone --quiet --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
yum install -y yum-utils setools-console openscap-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
podman pull registry.access.redhat.com/ubi8/ubi-minimal
podman pull registry.access.redhat.com/ubi8/ubi
podman pull registry.access.redhat.com/ubi8/ubi-init
echo "Container host is now ready."
