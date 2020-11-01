# General Preparation
git clone --quiet --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
yum install --quiet -y podman buildah skopeo skopeo-containers tree httpd-tools strace jq

# Lab 1
podman pull registry.access.redhat.com/ubi8/ubi-minimal
podman pull registry.access.redhat.com/ubi8/ubi
podman pull registry.access.redhat.com/ubi8/ubi-init
echo "Container host is now ready."
