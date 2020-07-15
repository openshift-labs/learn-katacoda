# allow mcrouter-operator to run as privileged
oc adm policy add-scc-to-user privileged system:serviceaccount:mcrouter:mcrouter-operator

#switch user to tutorial directory
cd ~/tutorial
clear
