#!/bin/bash
until [ -f /openshift.local.config/master/master-config.yaml ] ; do echo -n . && sleep 5; done
sed -i '213s/\.environments\.katacoda\.com/.http-proxy.katacoda.com/' /openshift.local.config/master/master-config.yaml && systemctl restart origin && ~/.launch.sh
~/.init/init-scenario.sh
