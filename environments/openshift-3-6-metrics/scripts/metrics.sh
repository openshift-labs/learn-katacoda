#!/bin/bash -e
export OAVERSION=3.6.173.0.63-1

cd /
/var/lib/openshift/openshift start --write-config /openshift.local.config/
cd ~

systemctl start docker
systemctl start origin

mkdir -p /etc/origin

yum install -y ansible-2.3.2.0 httpd-tools java-1.8.0-openjdk-headless yum-utils
curl -o o-a.tar.gz -k -L https://github.com/openshift/openshift-ansible/archive/openshift-ansible-${OAVERSION}.tar.gz
tar xzvf o-a.tar.gz

ln -s /openshift.local.config/master/ /etc/origin/master
ln -s /openshift.local.config/node/ /etc/origin/node

cat <<EOF > myinventory
[OSEv3:children]
nodes
masters

[OSEv3:vars]
deployment_type=origin
openshift_metrics_image_version=v3.6.0
openshift_metrics_cassandra_requests_memory=768Mi
openshift_metrics_cassandra_limits_memory=768Mi
openshift_metrics_hawkular_limits_memory=1Gi
openshift_metrics_hawkular_requests_memory=1Gi
openshift_metrics_heapster_limits_memory=64Mi
openshift_metrics_heapster_requests_memory=64Mi
openshift_metrics_cassandra_storage_type=emptydir

[nodes]
$(hostname) ansible_connection=local

[masters]
$(hostname) ansible_connection=local
EOF

until $(curl -o /dev/null -s -f -k https://localhost:8443/healthz); do
    printf '.'
    sleep 5
done

source ~/.bash_profile

ansible-playbook -i myinventory openshift-ansible-openshift-ansible-${OAVERSION}/playbooks/byo/openshift-cluster/openshift-metrics.yml -e "openshift_metrics_install_metrics=True" -e "openshift_metrics_hawkular_hostname=CHANGEME"

rm -Rf myinventory o-a.tar.gz

systemctl stop origin

umount /openshift.local.volumes/*/*/*/*/*

until $(rm -Rf /openshift\.*/); do
    printf '.'
    sleep 5
done

systemctl start docker
