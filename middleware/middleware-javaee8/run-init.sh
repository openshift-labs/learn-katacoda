mkdir -p /root/projects
cd /root/projects
rm -rf rhoar-getting-started
git clone https://github.com/openshift-katacoda/rhoar-getting-started
cd /root/projects/rhoar-getting-started/javaee/weather-app

curl -sL -w '' https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/assets/middleware/install-openjdk.sh > /tmp/jdk.sh

chmod a+x /tmp/jdk.sh
/tmp/jdk.sh

mvn clean package
