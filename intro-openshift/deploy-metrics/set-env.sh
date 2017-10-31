~/.launch.sh
export OAVERSION=3.6.173.0.63-1
sed -i '/ExecStartPre/d' /etc/systemd/system/origin.service
systemctl daemon-reload

yum install -y ansible httpd-tools java-1.8.0-openjdk-headless yum-utils

mkdir -p /etc/origin
ln -s /openshift.local.config/master/ /etc/origin/master
ln -s /openshift.local.config/node/ /etc/origin/node

curl -o o-a.tar.gz -k -L https://github.com/openshift/openshift-ansible/archive/openshift-ansible-${OAVERSION}.tar.gz
tar xzvf o-a.tar.gz

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

# ansible-playbook -i myinventory openshift-ansible-openshift-ansible-${OAVERSION}/playbooks/byo/openshift-cluster/openshift-metrics.yml -e "openshift_metrics_install_metrics=True" -e "openshift_metrics_hawkular_hostname=hawkular-metrics.$(awk '/subdomain/ { print $2 }' /etc/origin/master/master-config.yaml | sed 's/-80-/-443-/g')"
# systemctl restart origin.service
