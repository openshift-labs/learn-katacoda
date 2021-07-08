mkdir -p /root/projects/rhoar-getting-started/quarkus/panache-reactive
yum install tree -y

curl -sL -w '' https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/assets/middleware/install-openjdk.sh > /tmp/jdk.sh

chmod a+x /tmp/jdk.sh
/tmp/jdk.sh

