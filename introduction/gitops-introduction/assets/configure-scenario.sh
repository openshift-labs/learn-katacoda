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
}

function initialize_git {
  GOGS_NS="$1"
  GOGS_POD="$2"
  oc -n $GOGS_NS exec $GOGS_POD init-gogs "student" "student" "student@katacoda.com"
}

function initialize_git_local_user {
  git config --global user.email "student@katacoda.com"
  git config --global user.name "Student"
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
  cp -pr ~/federation-dev/gitops-introduction/simple-app ~/gitops-lab/
  cd ~/gitops-lab
  git add --all
  git commit -m "Simple app added"
  git push origin master
  cd ~/
}

function create_lab4_route_yaml {
  WC_DOMAIN="$1"
  cat > ~/route.yaml << EOF
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: reverse-words
spec:
  host: reverse-words.${WC_DOMAIN}
  port:
    targetPort: http
  tls:
    insecureEdgeTerminationPolicy: Redirect
    termination: edge
  to:
    kind: Service
    name: reverse-words
    weight: 100
status:
  ingress: []
EOF
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
curl -LOs https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 &> /dev/null
mv jq-linux64 /usr/local/bin/jq &> /dev/null
chmod +x /usr/local/bin/jq &> /dev/null
echo "Configuring required contexts and users..."
HOST_IP=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | awk -F "/" '{print $1}')
oc adm policy add-cluster-role-to-user cluster-admin admin &> /dev/null
oc config rename-context $(oc config current-context) cluster &> /dev/null
echo "Deploying ArgoCD..."
git clone https://github.com/openshift/federation-dev.git federation-dev/ &> /dev/null
cd federation-dev/ &> /dev/null
git checkout katacoda &> /dev/null
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
# Generate Route file for Lab4
create_lab4_route_yaml $WC_DOMAIN &> /dev/null
oc create namespace $GOGS_NS &> /dev/null
oc -n $GOGS_NS apply -f https://raw.githubusercontent.com/openshift/federation-dev/1873a8510dbc82f47367bebaf348996716ee6da4/automated-demo-gitops/yaml-resources/gogs/postgres.yaml &> /dev/null
wait_for_deployment $GOGS_NS postgres 0 &> /dev/null
sleep 5
curl -sL https://raw.githubusercontent.com/openshift/federation-dev/1873a8510dbc82f47367bebaf348996716ee6da4/automated-demo-gitops/yaml-resources/gogs/gogs.yaml | sed "s/changeMe/gogs.${WC_DOMAIN}"/g | oc -n $GOGS_NS apply -f - &> /dev/null
wait_for_deployment $GOGS_NS gogs 0 &> /dev/null
sleep 5
# Get Gogs Pod name
GOGS_POD=$(oc -n $GOGS_NS get pod -l name=gogs -o jsonpath='{.items[*].metadata.name}')
GOGS_ROUTE=$(oc -n $GOGS_NS get route gogs -o jsonpath='{.spec.host}')
echo "Initialize Git Server"
wait_for_gogs_api "${GOGS_ROUTE}"
initialize_git "${GOGS_NS}" "${GOGS_POD}" &> /dev/null
echo "initialize Git local user"
initialize_git_local_user &> /dev/null
echo "Initialize Git Repository"
initialize_git_repository "${GOGS_ROUTE}" &> /dev/null
echo "Initialize ArgoCD"
wait_for_argocd_api "${ARGOCD_ROUTE}"
initialize_argocd "${ARGOCD_ROUTE}" "${ARGOCD_SERVER_PASSWORD}" &> /dev/null
chmod +x /usr/local/bin/clean-lab3 &> /dev/null
echo "Lab tools and OpenShift Ready"
export PS1="$ "
stty echo
