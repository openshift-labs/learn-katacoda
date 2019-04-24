# General Preparation
git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
yum install -y podman buildah skopeo skopeo-containers tree httpd-tools strace

# Lab 4
podman pull registry.access.redhat.com/ubi7/ubi
skopeo copy containers-storage:registry.access.redhat.com/ubi7/ubi:latest docker-daemon:registry.access.redhat.com/ubi7/ubi:latest
cp ~/labs/lab3-step1/atomic-openshift-master.service /etc/systemd/system/atomic-openshift-master.service
cp ~/labs/lab3-step1/atomic-openshift-node.service /etc/systemd/system/atomic-openshift-node.service
systemctl disable --now origin.service
systemctl enable --now atomic-openshift-master.service; systemctl enable --now atomic-openshift-node.service

# Final Preparation
