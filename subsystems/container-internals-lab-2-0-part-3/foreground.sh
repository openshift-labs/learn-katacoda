# General Preparation
git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
yum install -y podman buildah skopeo skopeo-containers tree httpd-tools strace
cp ~/labs/lab1-step3/mega-proc.sh /usr/bin/mega-proc.sh

# Lab 3
podman pull registry.access.redhat.com/ubi7/ubi

echo "Container host is now ready."
