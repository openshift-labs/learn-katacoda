#!/bin/bash
mkdir -p /root/projects/rhoar-getting-started/quarkus/kafka
echo "-w \"\n\"" >> ~/.curlrc

curl -sL -w '' https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/assets/middleware/install-openjdk.sh > /tmp/jdk.sh
curl -sL -w '' https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/assets/middleware/install-github-cli.sh > /tmp/ghcli.sh
curl -sL -w '' https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/assets/middleware/setup-xdg-open.sh > /tmp/setup-xdg-open.sh
curl -sL -w '' https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/assets/middleware/run-gh-fork.sh > /root/projects/forkrepo.sh

chmod a+x /tmp/jdk.sh
chmod a+x /tmp/ghcli.sh
chmod a+x /tmp/setup-xdg-open.sh
chmod a+x /root/projects/forkrepo.sh

/tmp/setup-xdg-open.sh
/tmp/jdk.sh
/tmp/ghcli.sh