# General Preparation
git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
yum install -y podman buildah skopeo skopeo-containers tree httpd-tools strace

# Lab 1
podman pull registry.access.redhat.com/ubi7/ubi
podman pull quay.io/fatherlinux/linux-container-internals-2-0-introduction
echo "Container host is now ready."
