# General Preparation
yum install -y --quiet podman buildah skopeo tree httpd-tools strace
git clone --quiet --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
cp -f ~/labs/mega-proc.sh /usr/bin/mega-proc.sh

# Lab 5
docker pull registry.access.redhat.com/ubi7/ubi
docker pull quay.io/fatherlinux/wordpress:csc
docker pull quay.io/fatherlinux/httpd-php
docker pull openshift3/mysql-55-rhel7
git clone --quiet --depth 1 --single-branch --branch lab4-step1 https://github.com/fatherlinux/wordpress-demo.git ~/labs/wordpress-demo
~/labs/wordpress-demo/create.sh
sed -i s/wpfrontend-wordpress.apps.example.com/`hostname`/ ~/labs/wordpress-demo/wordpress-objects.yaml
git clone --quiet --depth 1 --single-branch --branch centos7 https://github.com/fatherlinux/container-supply-chain.git ~/labs/container-supply-chain/
oc adm policy add-role-to-user cluster-admin admin
#systemctl restart iptables

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
