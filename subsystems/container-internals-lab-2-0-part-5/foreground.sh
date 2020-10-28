# General Preparation
git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
yum install -y podman buildah skopeo tree httpd-tools strace
cp -f ~/labs/mega-proc.sh /usr/bin/mega-proc.sh

# Lab 5
podman pull registry.access.redhat.com/ubi7/ubi
git clone --depth 1 --single-branch --branch lab4-step1 https://github.com/fatherlinux/wordpress-demo.git ~/labs/wordpress-demo
~/labs/wordpress-demo/create.sh
sed -i s/wpfrontend-wordpress.apps.example.com/`hostname`/ ~/labs/wordpres-demo/wordpress-objects.yaml
git clone --depth 1 --single-branch --branch centos7 https://github.com/fatherlinux/container-supply-chain.git ~/labs/container-supply-chain/
systemctl restart iptables
oc adm policy add-role-to-user edit admin
echo "Container host is now ready."
