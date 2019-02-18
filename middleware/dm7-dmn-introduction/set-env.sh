#!/bin/bash
until [ -f /etc/origin/master/master-config.yaml ] ; do echo -n . && sleep 5; done
sed -i '181s/\.environments\.katacoda\.com/.http-proxy.katacoda.com/' /etc/origin/master/master-config.yaml && master-restart api && master-restart controllers
~/.init/init-scenario.sh
