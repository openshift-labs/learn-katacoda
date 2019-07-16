function timeout() {
  SECONDS=0; TIMEOUT=$1; shift
  until eval $*; do
    sleep 5
    [[ $SECONDS -gt $TIMEOUT ]] && echo "ERROR: Timed out" && exit -1
  done
}

function wait_for_all_pods {
  timeout 300 "oc get pods -n $1 && [[ \$(oc get pods -n $1 -o jsonpath='{.items[*].status.containerStatuses[*].ready}' | grep -c 'false') -eq 0 ]]" 
}
clear
/usr/local/bin/launch.sh
stty -echo
echo "export HOST1_IP=[[HOST_IP]]; export HOST2_IP=[[HOST2_IP]]" >> ~/.env; source ~/.env
export PS1=""
export KUBEFED_VERSION='v0.1.0-rc3'
export KUBEFEDCTL_VERSION='0.1.0-rc3'
clear
echo "Configuring required tools for Kubefed..."
curl -LOs https://github.com/kubernetes-sigs/kubefed/releases/download/${KUBEFED_VERSION}/kubefedctl-${KUBEFEDCTL_VERSION}-linux-amd64.tgz &> /dev/null
tar xzf kubefedctl-${KUBEFEDCTL_VERSION}-linux-amd64.tgz -C /usr/local/bin &> /dev/null
rm -f kubefedctl-${KUBEFEDCTL_VERSION}-linux-amd64.tgz &> /dev/null

# KubeFed download is not here anymore, now it's included in the cluster image, so we don't have to rely on GitHub's downloads.
# learn-katacoda/environments/openshift-3-11/scripts/13_kubefed.sh
echo "Configuring required contexts and users..."
HOST_IP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | awk -F "/" '{print $1}')
if [[ "$HOST_IP" == "$HOST1_IP" ]]; then
  oc adm policy add-cluster-role-to-user cluster-admin admin &> /dev/null
  oc login https://$HOST1_IP:8443/ --insecure-skip-tls-verify=true -u admin -p admin &> /dev/null
  oc config rename-context $(oc config current-context) cluster1 &> /dev/null
  oc login https://$HOST2_IP:8443/ --insecure-skip-tls-verify=true -u admin -p admin &> /dev/null
  oc config rename-context $(oc config current-context) cluster2 &> /dev/null
  oc config use cluster1 &> /dev/null
  # Wait for terminal2 to finish its tasks
  sleep 5 &> /dev/null
  echo "Deploying OLM on Cluster1..."
  git clone https://github.com/openshift/federation-dev.git &> /dev/null
  cd federation-dev/ && git checkout katacoda &> /dev/null
  oc create -f olm/01-olm.yaml &> /dev/null
  sleep 3 &> /dev/null
  oc create -f olm/02-olm.yaml &> /dev/null
  echo "Wait for OLM to be up and running"
  sleep 3 &> /dev/null
  wait_for_all_pods olm
  echo "Deploying Kubefed Operator on Cluster1..."
  oc create -f olm/03-kubefed-subscription.yaml &> /dev/null
  sleep 10 &> /dev/null
  wait_for_all_pods test-namespace
  echo "Deploying KubeFed Control Plane on Cluster1..."
  oc create -f olm/04-kubefed-resource.yaml &> /dev/null
  sleep 10 &> /dev/null
  wait_for_all_pods test-namespace
fi
if [[ "$HOST_IP" == "$HOST2_IP" ]]; then
  oc adm policy add-cluster-role-to-user cluster-admin admin &> /dev/null
  oc login https://$HOST2_IP:8443/ --insecure-skip-tls-verify=true -u admin -p admin &> /dev/null
  oc config rename-context $(oc config current-context) cluster2 &> /dev/null
  oc login https://$HOST1_IP:8443/ --insecure-skip-tls-verify=true -u admin -p admin &> /dev/null
  oc config rename-context $(oc config current-context) cluster1 &> /dev/null
  oc config use cluster2 &> /dev/null
fi
clear
export PS1="$ "
echo "Kubefed tools and OpenShift Ready"
stty echo
