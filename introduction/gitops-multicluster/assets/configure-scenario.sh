#!/bin/bash

function wait_for_gogs_api {
  READY=0
  WAIT=0
  MAX_WAIT=300
  GOGS_ROUTE="$1"
  while [ $READY -eq 0 ]
  do
    API_READY=$(curl -s http://${GOGS_ROUTE}/healthcheck | grep -c OK)
    if [ "0${API_READY}" == "01" ]
    then
      READY=1
    else
      sleep 5
      WAIT=$(expr $WAIT + 5)
    fi
    if [ $WAIT -ge $MAX_WAIT ]
    then
      exit 1
    fi
  done
}

function wait_for_argocd_api {
  READY=0
  WAIT=0
  MAX_WAIT=300
  ARGOCD_ROUTE="$1"
  while [ $READY -eq 0 ]
  do
    API_READY=$(curl -s -k https://${ARGOCD_ROUTE}/ | grep -c "Argo CD")
    if [ "0${API_READY}" == "01" ]
    then
      READY=1
    else
      sleep 5
      WAIT=$(expr $WAIT + 5)
    fi
    if [ $WAIT -ge $MAX_WAIT ]
    then
      exit 1
    fi
  done
}

function wait_for_deployment {
  READY=0
  WAIT=0
  MAX_WAIT=600
  DEPLOYMENT_NAMESPACE="$1"
  DEPLOYMENT_NAME="$2"
  IS_DEPLOYMENT_CONFIG="$3"
  K8S_OBJECT="deployment"
  if [ $IS_DEPLOYMENT_CONFIG -eq 1 ]
  then
    K8S_OBJECT="deploymentconfig"
  fi
  while [ $READY -eq 0 ]
  do
    DEPLOYMENT_EXISTS=$(oc -n ${DEPLOYMENT_NAMESPACE} get $K8S_OBJECT ${DEPLOYMENT_NAME} -o name | awk -F "/" '{print $2}')
    if [ "0${DEPLOYMENT_NAME}" == "0${DEPLOYMENT_EXISTS}" ]
    then
      READY=1
    else
      sleep 5
      WAIT=$(expr $WAIT + 5)
    fi
    if [ $WAIT -ge $MAX_WAIT ]
    then
      exit 1
    fi
  done
  READY=0
  WAIT=0
  DESIRED_REPLICAS=$(oc -n ${DEPLOYMENT_NAMESPACE} get $K8S_OBJECT ${DEPLOYMENT_NAME} -o jsonpath='{ .spec.replicas }')
  while [ $READY -eq 0 ]
  do
    CLUSTER_REPLICAS_READY=$(oc -n ${DEPLOYMENT_NAMESPACE} get $K8S_OBJECT ${DEPLOYMENT_NAME} -o jsonpath='{ .status.readyReplicas }')
    if [ "0$CLUSTER_REPLICAS_READY" -eq "0$DESIRED_REPLICAS" ]
    then
      READY=1
    else
      sleep 5
      WAIT=$(expr $WAIT + 5) 
    fi
    if [ $WAIT -ge $MAX_WAIT ]
    then
      exit 1
    fi
  done
}

function initialize_argocd {
  ARGOCD_ROUTE="$1"
  ARGOCD_SERVER_PASSWORD="$2"
  argocd --insecure --grpc-web login ${ARGOCD_ROUTE}:443 --username admin --password ${ARGOCD_SERVER_PASSWORD}
  sleep 2
  argocd --insecure --grpc-web --server ${ARGOCD_ROUTE}:443 account update-password --current-password ${ARGOCD_SERVER_PASSWORD} --new-password student
  sleep 2
  argocd cluster add pre &> /tmp/clusteradd
  if [ $? -ne 0 ]
  then
    SECRET_NAME=$(cat /tmp/clusteradd | grep Secret | perl -pe 's|.*?(argocd-manager-dockercfg-.*?)\\.*|\1|')
    oc --context pre -n kube-system delete secret $SECRET_NAME &> /dev/null
    argocd cluster add pre &> /tmp/clusteradd
  fi
  sleep 2
  argocd cluster add pro &> /tmp/clusteradd
  if [ $? -ne 0 ]
  then
  SECRET_NAME=$(cat /tmp/clusteradd | grep Secret | perl -pe 's|.*?(argocd-manager-dockercfg-.*?)\\.*|\1|')
  oc --context pro -n kube-system delete secret $SECRET_NAME &> /dev/null
  argocd cluster add pro &> /tmp/clusteradd
  fi
}

function initialize_git {
  GOGS_NS="$1"
  GOGS_POD="$2"
  oc -n $GOGS_NS exec $GOGS_POD init-gogs "student" "student" "student@katacoda.com"
}

function initialize_git_repository {
  GOGS_ROUTE="$1"
  GOGS_TOKEN_OUTPUT=$(curl -s -X POST -H 'Content-Type: application/json' --data '{"name":"api"}' "http://student:student@$GOGS_ROUTE/api/v1/users/student/tokens")
  GOGS_TOKEN=$(echo $GOGS_TOKEN_OUTPUT | jq -r '.sha1')
  REPO_DATA='{"name": "gitops-lab", "description": "Katacoda GitOps Lab Repository", "readme": "Default", "auto_init": true, "private": false}'
  sleep 2
  curl -s -X POST -H 'Content-Type: application/json' -H "Authorization: token $GOGS_TOKEN" --data "$REPO_DATA" "http://$GOGS_ROUTE/api/v1/admin/users/student/repos"
  sleep 2
  git clone "http://student:student@$GOGS_ROUTE/student/gitops-lab.git" ~/gitops-lab
  sleep 2
  cd ~/gitops-lab
  git checkout -b pro
  cd ~/gitops-demo
  git checkout pro
  cd ../
  cp -pr ~/gitops-demo/* ~/gitops-lab/
  cd ~/gitops-lab/
  sed -i "s/LoadBalancer/ClusterIP/" reversewords_app/base/service.yaml
  git add --all
  git commit -m "Simple app added pro branch"
  git push origin pro
  git checkout master
  git checkout -b pre
  cd ~/gitops-demo
  git checkout pre
  cd ../
  cp -pr ~/gitops-demo/* ~/gitops-lab/
  cd ~/gitops-lab/
  sed -i "s/LoadBalancer/ClusterIP/" reversewords_app/base/service.yaml
  git add --all
  git commit -m "Simple app added pre branch"
  git push origin pre
  git branch master -D
  git checkout pro
  cd ../  
}

clear
/usr/local/bin/launch.sh
clear
stty -echo
export PS1=""
export ARGOCD_VERSION='v1.2.2'
export ARGOCD_NS='argocd'
export GOGS_NS='gogs'
clear
echo "Configuring required tools for ArgoCD..."
curl -LOs https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64 &> /dev/null
mv argocd-linux-amd64 /usr/local/bin/argocd &> /dev/null
chmod +x /usr/local/bin/argocd &> /dev/null
echo "Configuring required contexts and users..."
oc adm policy add-cluster-role-to-user cluster-admin admin &> /dev/null
oc login https://$HOST1_IP:8443/ --insecure-skip-tls-verify=true -u admin -p admin &> /dev/null
oc config rename-context $(oc config current-context) pre &> /dev/null
oc login https://$HOST2_IP:8443/ --insecure-skip-tls-verify=true -u admin -p admin &> /dev/null
oc config rename-context $(oc config current-context) pro &> /dev/null
oc config use pre &> /dev/null
echo "Configuring PVs..."
mkdir -p /data/pv-0{1..4} &> /dev/null
chmod 0777 /data/pv-* &> /dev/null
chcon -t svirt_sandbox_file_t /data/pv-* &> /dev/null
oc create -f volumes.json &> /dev/null
echo "Deploying ArgoCD..."
git clone https://github.com/openshift/federation-dev federation-dev/ &> /dev/null
cd federation-dev/ &> /dev/null
git checkout katacoda &> /dev/null
cd ../ &> /dev/null
git clone https://github.com/mvazquezc/gitops-demo gitops-demo/ &> /dev/null
cd gitops-demo/ &> /dev/null
git checkout pro &> /dev/null
cd ../ &> /dev/null
oc create namespace $ARGOCD_NS &> /dev/null
oc -n $ARGOCD_NS apply -f https://raw.githubusercontent.com/argoproj/argo-cd/v1.2.2/manifests/install.yaml &> /dev/null
echo "Waiting for ArgoCD to be up and running"
wait_for_deployment $ARGOCD_NS argocd-server 0 &> /dev/null
sleep 2
ARGOCD_SERVER_PASSWORD=$(oc -n $ARGOCD_NS get pod -l "app.kubernetes.io/name=argocd-server" -o jsonpath='{.items[*].metadata.name}')
PATCH='{"spec":{"template":{"spec":{"$setElementOrder/containers":[{"name":"argocd-server"}],"containers":[{"command":["argocd-server","--insecure","--staticassets","/shared/app"],"name":"argocd-server"}]}}}}'
oc -n $ARGOCD_NS patch deployment argocd-server -p $PATCH &> /dev/null
oc -n $ARGOCD_NS create route edge argocd-server --service=argocd-server --port=http --insecure-policy=Redirect &> /dev/null
# Patch Argo CD CM so it doesn't try to validate the OCP Routes status
oc -n $ARGOCD_NS patch configmap argocd-cm -p '{"data":{"resource.customizations":"route.openshift.io/Route:\n  ignoreDifferences: |\n    jsonPointers:\n    - /status/ingress\n"}}' &> /dev/null
sleep 10
ARGOCD_ROUTE=$(oc -n $ARGOCD_NS get route argocd-server -o jsonpath='{.spec.host}')
wait_for_deployment $ARGOCD_NS argocd-server 0 &> /dev/null
echo "Deploying Gogs Git Server..."
# Get Cluster Wildcard domain
WC_DOMAIN=$(oc -n $ARGOCD_NS get route argocd-server -o jsonpath='{.spec.host}' | sed "s/.*argocd-server-argocd.\(.*\)/\1/g")
oc create namespace $GOGS_NS &> /dev/null
oc process -f federation-dev/gitops-introduction/gogs/gogs-persistent-template.yaml -p HOSTNAME="gogs.${WC_DOMAIN}" | oc -n $GOGS_NS apply -f - &> /dev/null
sleep 5
wait_for_deployment $GOGS_NS gogs-postgresql 1 &> /dev/null
wait_for_deployment $GOGS_NS gogs 1 &> /dev/null
sleep 5
# Get Gogs Pod name
GOGS_POD=$(oc -n $GOGS_NS get pod -l app=gogs -o jsonpath='{.items[*].metadata.name}')
GOGS_ROUTE=$(oc -n $GOGS_NS get route gogs -o jsonpath='{.spec.host}')
echo "Initialize Git Server"
wait_for_gogs_api "${GOGS_ROUTE}"
initialize_git "${GOGS_NS}" "${GOGS_POD}" &> /dev/null
echo "Initialize Git Repository"
initialize_git_repository "${GOGS_ROUTE}" &> /dev/null
echo "Initialize ArgoCD"
wait_for_argocd_api "${ARGOCD_ROUTE}"
initialize_argocd "${ARGOCD_ROUTE}" "${ARGOCD_SERVER_PASSWORD}" &> /dev/null
echo "Lab tools and OpenShift Ready"
export PS1="$ "
stty echo
