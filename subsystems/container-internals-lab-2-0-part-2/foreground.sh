# General Preparation
git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
yum install -y yum-plugin-versionlock
yum versionlock podman-1.3.2
yum remove -y podman
yum install -y podman buildah skopeo skopeo-containers tree httpd-tools strace

# Lab 2
yum install -y podman buildah skopeo
podman pull registry.access.redhat.com/ubi7/ubi
podman pull registry.access.redhat.com/ubi7/ubi-minimal

echo "Container host is now ready."
