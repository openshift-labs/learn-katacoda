#!/bin/bash

echo "Initializing..."
stty -echo
clear
echo "export HOST1_IP=[[HOST_IP]]; export HOST2_IP=[[HOST2_IP]]" >> ~/.env; source ~/.env
HOST_IP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | awk -F "/" '{print $1}')
if [[ "$HOST_IP" == "$HOST1_IP" ]]
then
  clear
  until $(ls /var/tmp/configure-scenario.sh &> /dev/null); do (echo -n .; sleep 2); done;
  clear
  stty echo
  /bin/bash /var/tmp/configure-scenario.sh
fi
stty -echo
sleep 3
clear
if [[ "$HOST_IP" == "$HOST2_IP" ]]
then
  stty -echo
  oc adm policy add-cluster-role-to-user cluster-admin admin &> /dev/null
  oc login https://$HOST2_IP:8443/ --insecure-skip-tls-verify=true -u admin -p admin &> /dev/null
  oc config rename-context $(oc config current-context) pro &> /dev/null
  oc login https://$HOST1_IP:8443/ --insecure-skip-tls-verify=true -u admin -p admin &> /dev/null
  oc config rename-context $(oc config current-context) pre &> /dev/null
  oc config use pro &> /dev/null
  clear
  stty echo
fi
stty echo
clear
