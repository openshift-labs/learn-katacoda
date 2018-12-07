ip addr show 

export VERSION=v3.10.0
export ARCH=v3.10.0-dd10d17-linux
export URL=https://github.com/openshift/origin/releases/download/$VERSION
df -h
setenforce 0

mkdir -p /openshift
yum remove NetworkManager -y
yum install NetworkManager -y
yum install epel-release -y
yum install ca-certificates git nfs-utils bash-completion ansible docker java-1.8.0-openjdk-headless -y

yum -y install python-pip
pip install ansible==2.7.1
ansible --version

hostnamectl set-hostname master

function atoi
{
IP=$1; IPNUM=0
for (( i=0 ; i<4 ; ++i )); do
((IPNUM+=${IP%%.*}*$((256**$((3-${i}))))))
IP=${IP#*.}
done
echo $IPNUM 
} 


export INTERNAL_IP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
export PUBLIC_IP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
export HOST_SUBDOMAIN=$(atoi $INTERNAL_IP)
export HOST_SUBDOMAIN_PUBLIC=$(atoi $PUBLIC_IP)
export KATACODA_HOST=kitek01

git clone https://github.com/openshift/openshift-ansible /opt/openshift-ansible
cd /opt/openshift-ansible
git checkout -b 3-10 remotes/origin/release-3.10
cp /opt/hosts.localhost inventory/hosts.localhost
sed -i s/HOST_SUBDOMAIN/$HOST_SUBDOMAIN/g inventory/hosts.localhost
sed -i s/INTERNAL_IP/$INTERNAL_IP/g inventory/hosts.localhost
sed -i s/KATACODA_HOST/$KATACODA_HOST/g inventory/hosts.localhost
cat inventory/hosts.localhost

sudo ansible-playbook -i inventory/hosts.localhost playbooks/prerequisites.yml
# sudo ansible-playbook -i inventory/hosts.localhost playbooks/deploy_cluster.yml
# sudo ansible-playbook -i inventory/hosts.localhost playbooks/adhoc/uninstall.yml
cd -

systemctl restart NetworkManager
iptables --flush
echo "nameserver 8.8.8.8" > /etc/resolv.conf


# curl -o openshift.tar.gz -L $URL/openshift-origin-server-$ARCH-64bit.tar.gz
# tar -xvf openshift.tar.gz
# rm openshift.tar.gz
# mv openshift-origin-server-$ARCH-64bit/ /var/lib/openshift/

curl -o oc.tar.gz -L $URL/openshift-origin-client-tools-$ARCH-64bit.tar.gz
tar -xvf oc.tar.gz
rm oc.tar.gz

mv openshift-origin-client-tools-$ARCH-64bit/oc /usr/bin/oc
rm -rf ~/*
chmod +x /usr/bin/oc
/usr/bin/oc version
echo $PATH
oc version

# yum install bash-completion centos-release-openshift-origin origin-clients -y

# oc cluster up --base-dir=/katacoda/ --enable=[*] 

# oc --config=/katacoda/config/master/admin.kubeconfig scale dc router -n default --replicas=0
# oc --config=/katacoda/config/master/admin.kubeconfig scale dc docker-registry -n default  --replicas=0

# sleep 60

# oc cluster down

# docker rm -f $(docker ps -a -q)

# umount /katacoda/volumes/pods/*/volumes/*/*
# rm -Rf /katacoda/{pv,volumes}/*
# rm -Rf /var/log/containers/*
# rm -Rf /var/log/pods/*

cat <<-EOF > /etc/systemd/system/origin.service
[Unit]
Description=OpenShift
After=docker.target network.target
[Service]
Type=notify
ExecStart=/opt/oc_cluster_up_start.sh
Restart=always
RestartSec=3
TimeoutSec=30
[Install]
WantedBy=multi-user.target
EOF
# systemctl enable origin

# copy ssh key
mkdir -p ~/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqogWTBOZvsLcz7Zxz7i4+Z00WA01Y+xpNsvUiC6bkB8F4PhuVkKMn+ww7F/UtLcQ9qO6U1K8f5FpkDmeQQLvV7uYCnG7X63ia+njPgF8euF5rpWvmjG5Zz/6gLGf8+wFNC4yXyjU7G7Vce59/JdbaPUdOmA3aL2WKMxoea/IDOTEAORFcyMLNNJdy0yYNxLfEl7w3IY12po/cPb2VKeqJqi3UqwJroDYjCOt5fS4Fp0tvzvbiXP8+nbhd0uTTEkgtl3/FU0ozQBAHgO6UlbSV1sJEIjZG+543FtRfV0tbmUyT7+N0NGOZYJ3FQ1B/MrP6H8O/8YhiaQDLwkL5zhxPqW9cyAZw207uZbM26ohfCQUMmFoYJ9fBA/dt7aXbw5rb0lihFYZMq94NUi3ABLDBEsT9J5+mJomdlUHDwHxztcjO8JnThP5iBcYmNiqAnhbn71Avr8Zz1vHVP0TFC8f40NnK/A7nwTQw0aQ+H0u+EGrx+2gVmSUlwQyDDUlHJpEI0IefWtdmBqYvMyfVDf8SGSolkcXUJxX63iCFEyPMyMLUWLbPcwRhlUn6G6NVDI6sLwfveeXFJppuSMx+Wqc3ZmyEHIj/mVuEuygVke3Bd4/v8e4o6adR93yF/Fuq0Q0bMhgf2xCwVFSaqlta/o5m0wMNwCO3NuDLCZjIFj3+vw== course@katacoda.com' >> ~/.ssh/authorized_keys

touch ~/.hushlogin
echo 'echo "Starting OpenShift"' >> /usr/local/bin/launch.sh
echo 'echo "Waiting for OpenShift to start... This may take a couple of minutes"' >> /usr/local/bin/launch.sh
echo 'until $(oc status &> /dev/null); do' >> /usr/local/bin/launch.sh
echo '  echo -n "."' >> /usr/local/bin/launch.sh
echo '  sleep 1' >> /usr/local/bin/launch.sh
echo 'done' >> /usr/local/bin/launch.sh
echo 'echo "OpenShift started. "' >> /usr/local/bin/launch.sh
echo 'echo -n "Configuring... "' >> /usr/local/bin/launch.sh
echo 'while [ $(oc get pods -n openshift-web-console 2> /dev/null | wc -l ) -ne 2 ]; do' >> /usr/local/bin/launch.sh
echo '  echo -n "."' >> /usr/local/bin/launch.sh
echo '  sleep 1' >> /usr/local/bin/launch.sh
echo 'done' >> /usr/local/bin/launch.sh
echo 'echo ""' >> /usr/local/bin/launch.sh
echo 'echo "OpenShift Ready"' >> /usr/local/bin/launch.sh

chmod +x /usr/local/bin/launch.sh

echo "echo 127.0.0.1 \$HOSTNAME >> /etc/hosts; hostname -I | awk '{print \$1 \" master\"}' | tee -a /etc/hosts" >> /root/.set-hostname
chmod +x /root/.set-hostname

curl -Lk https://raw.githubusercontent.com/openshift/origin/master/examples/image-streams/image-streams-centos7.json -o /openshift/image-streams-centos7.json
# oc create -f /openshift/image-streams-centos7.json --namespace=openshift
# oc policy add-role-to-user system:masters developer


echo 'source <( oc completion bash )' >> ~/.bashrc
echo 'export PS1="$ "' >> ~/.bashrc

rm -rf ansible/ openshift openshift_bootstrap/ original-ks.cfg
