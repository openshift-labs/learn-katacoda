clear
/usr/local/bin/launch.sh
stty -echo
echo "export HOST1_IP=[[HOST_IP]]; export HOST2_IP=[[HOST2_IP]]" >> ~/.env; source ~/.env
export PS1=""
export KUBEFED_VERSION='v0.0.4'
export FEDERATION_DEV_TAG='v0.0.4'
clear
echo "Configuring required tools for Federation V2..."
curl -LOs https://github.com/kubernetes-sigs/federation-v2/releases/download/${KUBEFED_VERSION}/kubefed2.tar.gz &> /dev/null
tar xzf kubefed2.tar.gz -C /usr/local/bin &> /dev/null
rm -f kubefed2.tar.gz &> /dev/null
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
  echo "Deploying Federation V2 Control Plane on Cluster1..."
  oc create clusterrolebinding federation-admin --clusterrole="cluster-admin" --serviceaccount="federation-system:default" &> /dev/null
  git clone --recurse-submodules https://github.com/openshift/federation-dev.git &> /dev/null
  cd federation-dev/ && git checkout $FEDERATION_DEV_TAG &> /dev/null
  cd federation-v2 &> /dev/null
  oc create ns federation-system &> /dev/null
  oc create ns kube-multicluster-public &> /dev/null
  oc -n federation-system apply --validate=false -f hack/install-latest.yaml &> /dev/null
  oc apply --validate=false -f vendor/k8s.io/cluster-registry/cluster-registry-crd.yaml &> /dev/null
  for filename in ./config/federatedirectives/*.yaml
  do
    kubefed2 federate enable -f "${filename}" --federation-namespace=federation-system &> /dev/null
  done
  cd ../..
  rm -rf federation-dev/ &> /dev/null
  cat > /var/tmp/namespace.yaml << EOF
apiVersion: v1
kind: List
items:
- apiVersion: v1
  kind: Namespace
  metadata:
    name: test-namespace
- apiVersion: primitives.federation.k8s.io/v1alpha1
  kind: FederatedNamespacePlacement
  metadata:
    name: test-namespace
    namespace: test-namespace
  spec:
    clusterNames:
    - cluster1
    - cluster2
EOF
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
echo "Federation V2 tools and OpenShift Ready"
stty echo
