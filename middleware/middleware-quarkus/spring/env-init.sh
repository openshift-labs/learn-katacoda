mkdir -p /root/projects/quarkus

curl -sL -w '' https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/assets/middleware/install-openjdk.sh > /tmp/jdk.sh

chmod a+x /tmp/jdk.sh
/tmp/jdk.sh

curl -sL -w '' https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/assets/middleware/install-graalvm.sh > /tmp/graalvm.sh

chmod a+x /tmp/graalvm.sh
/tmp/graalvm.sh

echo "-w \"\\\n\"" >> ~/.curlrc