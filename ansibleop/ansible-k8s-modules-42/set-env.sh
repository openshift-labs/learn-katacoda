cd /root/tutorial
ansible-galaxy init example-role --offline >> /dev/null
wget -q https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/ansibleop/ansible-k8s-modules/assets/myhosts -O /root/tutorial/myhosts
wget -q https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/ansibleop/ansible-k8s-modules/assets/nginx-deployment.yml -O /root/tutorial/nginx-deployment.yml
wget -q https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/ansibleop/ansible-k8s-modules/assets/playbook.yml -O /root/tutorial/playbook.yml
oc adm policy add-scc-to-user anyuid system:serviceaccount:test:default
clear