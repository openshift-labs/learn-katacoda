# General Preparation
git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
yum install -y yum-plugin-versionloc
yum versionlock podman-1.3.2
yum remove podman
yum install -y podman buildah skopeo skopeo-containers tree httpd-tools strace

# Lab 1
podman pull registry.access.redhat.com/ubi7/ubi
podman pull quay.io/fatherlinux/linux-container-internals-2-0-introduction
skopeo copy containers-storage:registry.access.redhat.com/ubi7/ubi:latest docker-daemon:registry.access.redhat.com/ubi7/ubi:latest
skopeo copy containers-storage:quay.io/fatherlinux/linux-container-internals-2-0-introduction:latest docker-daemon:quay.io/fatherlinux/linux-container-internals-2-0-introduction:latest
echo "Container host is now ready."
