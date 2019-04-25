# General Preparation
ssh root@host01 'git clone --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs'
ssh root@host01 'yum install -y podman buildah skopeo skopeo-containers tree httpd-tools strace &'
ssh root@host01 'cp ~/labs/lab1-step3/mega-proc.sh /usr/bin/mega-proc.sh'

# Lab 3

echo "Container host is now ready."
