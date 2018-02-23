#!/bin/bash
until [ -f /openshift.local.config/master/master-config.yaml ] ; do echo -n . && sleep 5; done
#sed -i 's/\.environments\.katacoda\.com/.openstack-environments.katacoda.com/g' /openshift.local.config/master/master-config.yaml && systemctl restart origin && ~/.launch.sh
sed -i '213s/\.environments\.katacoda\.com/.openstack-environments.katacoda.com/' /openshift.local.config/master/master-config.yaml && systemctl restart origin && ~/.launch.sh
#~/.launch.sh

~/.init/init-scenario.sh
