# General Preparation
git clone --quiet --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
yum install --quiet -y podman buildah skopeo skopeo-containers tree httpd-tools strace jq

# Lab 1
podman pull registry.access.redhat.com/ubi7/ubi
echo "Container host is now ready."
