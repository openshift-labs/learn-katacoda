# General Preparation
# General Preparation
git clone --quiet --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
yum install --quiet -y podman buildah skopeo skopeo-containers tree httpd-tools strace

# Lab 1
podman pull registry.access.redhat.com/ubi7/ubi
podman pull quay.io/fatherlinux/linux-container-internals-2-0-introduction
skopeo copy containers-storage:registry.access.redhat.com/ubi7/ubi:latest docker-daemon:registry.access.redhat.com/ubi7/ubi:latest
skopeo copy containers-storage:quay.io/fatherlinux/linux-container-internals-2-0-introduction:latest docker-daemon:quay.io/fatherlinux/linux-container-internals-2-0-introduction:latest
echo "Container host is now ready."
