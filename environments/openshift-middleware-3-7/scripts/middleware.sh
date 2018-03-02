# Bug in the Redhat Docker Image? 
# https://bugzilla.redhat.com/show_bug.cgi?id=1510187#c2
# https://www.mail-archive.com/users@lists.openshift.redhat.com/msg04484.html
yum install python-rhsm-certificates -y
mkdir -p /etc/docker/certs.d/registry.access.redhat.com/
ln -s /etc/rhsm/ca/redhat-uep.pem /etc/docker/certs.d/registry.access.redhat.com/redhat-ca.crt

yum install java-1.8.0-openjdk-devel tree -y
wget http://www.eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
tar xzf apache-maven-3.3.9-bin.tar.gz
rm -rf apache-maven-3.3.9-bin.tar.gz
mkdir /usr/local/maven
mv apache-maven-3.3.9/ /usr/local/maven/
alternatives --install /usr/bin/mvn mvn /usr/local/maven/apache-maven-3.3.9/bin/mvn 1

mkdir -p /root/installation
wget -c https://github.com/istio/istio/releases/download/0.6.0/istio-0.6.0-linux.tar.gz -P /root/installation
