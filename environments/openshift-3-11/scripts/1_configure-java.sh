# Bug in the Redhat Docker Image? 
# https://bugzilla.redhat.com/show_bug.cgi?id=1510187#c2
# https://www.mail-archive.com/users@lists.openshift.redhat.com/msg04484.html
yum install python-rhsm-certificates -y
mkdir -p /etc/docker/certs.d/registry.access.redhat.com/
mkdir -p /etc/rhsm/ca/
touch /etc/rhsm/ca/redhat-uep.pem
# ln -s /etc/rhsm/ca/redhat-uep.pem /etc/docker/certs.d/registry.access.redhat.com/redhat-ca.crt

yum install java-1.8.0-openjdk-devel tree -y
export MVN_VERSION=3.6.2
wget http://www.eu.apache.org/dist/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz
if [ $? -eq 0 ]; then
  echo "Maven downloaded successfully"
else
  echo "Maven has deleted the $MVN_VERSION release. Exit build as no point continuing."
  exit 1
fi
tar xzf apache-maven-$MVN_VERSION-bin.tar.gz
rm -rf apache-maven-$MVN_VERSION-bin.tar.gz
mkdir /usr/local/maven
mv apache-maven-$MVN_VERSION/ /usr/local/maven/
alternatives --install /usr/bin/mvn mvn /usr/local/maven/apache-maven-$MVN_VERSION/bin/mvn 1

yum install wget -y
sudo mkdir -p /root/installation
sudo wget -c https://github.com/istio/istio/releases/download/1.0.5/istio-1.0.5-linux.tar.gz -P /root/installation

yum install dnsmasq -y;
systemctl restart dbus dnsmasq; systemctl restart systemd-logind;
