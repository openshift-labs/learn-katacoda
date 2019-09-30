#!/bin/bash
stty -echo
export PS1=""
clear

function generate_kustomization {
  BRANCH="$1"
  WC_DOMAIN="$2"
  cd ~/gitops-lab/
  git checkout $BRANCH
  cat > ~/gitops-lab/reversewords_app/base/route.yaml << EOF
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: reverse-words
spec:
  host: hostnamehere
  port:
    targetPort: http
  to:
    kind: Service
    name: reverse-words
    weight: 100
status:
  ingress: []
EOF
  cat > ~/gitops-lab/reversewords_app/overlays/$BRANCH/route.yaml << EOF
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: reverse-words
spec:
  host: reverse-words-$BRANCH.${WC_DOMAIN}
EOF
  echo "- route.yaml" >> ~/gitops-lab/reversewords_app/base/kustomization.yaml
  echo "- route.yaml" >> ~/gitops-lab/reversewords_app/overlays/$BRANCH/kustomization.yaml
  git add reversewords_app/base/route.yaml reversewords_app/base/kustomization.yaml reversewords_app/overlays/$BRANCH/route.yaml reversewords_app/overlays/$BRANCH/kustomization.yaml
  git commit -m "Added $BRANCH kustomization"
  git push origin $BRANCH
}

function delete_argocd_app {

  APP_NAME=$1
  ARGOCD_APP=$(argocd app list -o name | grep $APP_NAME)
  if [ "0$(echo ${ARGOCD_APP} | grep -c $APP_NAME)" -eq "01" ]
  then
    argocd app delete "${ARGOCD_APP}" --cascade
  else
    echo "App not found"
  fi
}

cd ~/gitops-lab/
git checkout pro
if [ ! -s ~/gitops-lab/reversewords_app/base/route.yaml ]
then
  # Get Pro Cluster Wildcard domain
  WC_DOMAIN_PRO=$(oc --context pro -n openshift-console get route console -o jsonpath='{.spec.host}' | sed "s/.*console.\(.*\)/\1/g")
  generate_kustomization pro $WC_DOMAIN_PRO
fi

cd ~/gitops-lab/
git checkout pre
if [ ! -s ~/gitops-lab/reversewords_app/base/route.yaml ]
then
  # Get Pre Cluster Wildcard domain
  WC_DOMAIN_PRE=$(oc --context pre -n openshift-console get route console -o jsonpath='{.spec.host}' | sed "s/.*console.\(.*\)/\1/g")
  generate_kustomization pre $WC_DOMAIN_PRE
fi

delete_argocd_app pre-reverse-words-app
delete_argocd_app pro-reverse-words-app

export PS1="$ "
stty echo
