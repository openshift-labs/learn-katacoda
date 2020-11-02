# General Preparation
git clone --quiet --depth 1 https://github.com/fatherlinux/container-internals-lab.git ~/labs
yum install -y yum-utils setools-console openscap-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
podman pull registry.access.redhat.com/ubi8/ubi-minimal
podman pull registry.access.redhat.com/ubi8/ubi
podman pull registry.access.redhat.com/ubi8/ubi-init
podman pull registry.access.redhat.com/ubi8/ubi:8.0-126
podman pull registry.access.redhat.com/rhscl/nginx-114-rhel7

# Start container for OSCAP reports
mkdir ~/html
podman run -p 80:8080 -id --name nginx -v /root/html:/opt/app-root/src/:Z registry.access.redhat.com/rhscl/nginx-114-rhel7 nginx -g 'daemon off;'
echo "Container host is now ready."
