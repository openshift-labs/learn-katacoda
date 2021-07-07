# General Preparation
git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
yum install -y podman buildah skopeo skopeo-containers tree httpd-tools strace
yum install -y https://cbs.centos.org/kojifiles/packages/podman/1.5.1/3.el7/noarch/podman-manpages-1.5.1-3.el7.noarch.rpm \
https://cbs.centos.org/kojifiles/packages/podman/1.5.1/3.el7/x86_64/podman-1.5.1-3.el7.x86_64.rpm \
https://cbs.centos.org/kojifiles/packages/slirp4netns/0.3.0/2.git4992082.el7/x86_64/slirp4netns-0.3.0-2.git4992082.el7.x86_64.rpm \
https://cbs.centos.org/kojifiles/packages/libseccomp/2.4.1/0.el7/x86_64/libseccomp-2.4.1-0.el7.x86_64.rpm
cp -f ~/labs/lab1-step3/mega-proc.sh /usr/bin/mega-proc.sh

# Lab 4
podman pull registry.access.redhat.com/ubi7/ubi
podman pull quay.io/fatherlinux/on-off-container
skopeo copy containers-storage:registry.access.redhat.com/ubi7/ubi:latest docker-daemon:registry.access.redhat.com/ubi7/ubi:latest
#cp ~/labs/lab3-step1/atomic-openshift-master.service /etc/systemd/system/atomic-openshift-master.service
#cp ~/labs/lab3-step1/atomic-openshift-node.service /etc/systemd/system/atomic-openshift-node.service
#systemctl disable --now origin.service
#systemctl enable --now atomic-openshift-master.service; systemctl enable --now atomic-openshift-node.service

# This block is only needed for openshift 3.x environments
if [[ $(which jq) ]]; then
  echo "jq installed"
else
  echo "installing jq from GH" # yum doen't seem to be working
  wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
  chmod +x jq-linux64
  mv jq-linux64 /usr/local/bin/jq
fi

echo "Container host is now ready."
