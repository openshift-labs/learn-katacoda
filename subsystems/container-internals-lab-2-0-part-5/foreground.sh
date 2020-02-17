# General Preparation
git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
yum install -y podman buildah skopeo skopeo-containers tree httpd-tools strace
yum install -y https://cbs.centos.org/kojifiles/packages/podman/1.5.1/3.el7/noarch/podman-manpages-1.5.1-3.el7.noarch.rpm \
https://cbs.centos.org/kojifiles/packages/podman/1.5.1/3.el7/x86_64/podman-1.5.1-3.el7.x86_64.rpm \
https://cbs.centos.org/kojifiles/packages/slirp4netns/0.3.0/2.git4992082.el7/x86_64/slirp4netns-0.3.0-2.git4992082.el7.x86_64.rpm \
https://cbs.centos.org/kojifiles/packages/libseccomp/2.4.1/0.el7/x86_64/libseccomp-2.4.1-0.el7.x86_64.rpm
cp -f ~/labs/lab1-step3/mega-proc.sh /usr/bin/mega-proc.sh

# Lab 5
podman pull registry.access.redhat.com/ubi7/ubi
git clone --depth 1 --single-branch --branch lab4-step1 https://github.com/fatherlinux/wordpress-demo.git ~/labs/lab4-step1
~/labs/lab4-step1/create.sh
sed -i s/wpfrontend-wordpress.apps.example.com/`hostname`/ ~/labs/lab4-step1/wordpress-objects.yaml
git clone --depth 1 --single-branch --branch centos7 https://github.com/fatherlinux/container-supply-chain.git ~/labs/lab2-step4/
systemctl restart iptables
oc adm policy add-role-to-user edit admin
echo "Container host is now ready."
