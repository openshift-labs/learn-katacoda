# General Preparation
git clone --quiet --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
yum install --quiet -y podman buildah skopeo skopeo-containers tree httpd-tools strace jq

# Lab 6
<<<<<<< HEAD
podman pull registry.fedoraproject.org/fedora
=======
podman pull docker.io/library/fedora
>>>>>>> upstream/master
echo "Container host is now ready."
