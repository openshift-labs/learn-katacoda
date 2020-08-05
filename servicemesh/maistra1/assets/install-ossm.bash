#!/bin/bash

echo "Starting OpenShift Service Mesh install."
echo "Please wait..."
echo "Subscribing to the operators..."
#install the ServiceMesh operator
cat <<EOM | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: maistraoperator
  namespace: openshift-operators
spec:
  channel: 'stable'
  installPlanApproval: Automatic
  name: maistraoperator
  source: community-operators
  sourceNamespace: openshift-marketplace
EOM

#install the Kiali operator
cat <<EOM | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: kiali
  namespace: openshift-operators
spec:
  channel: 'stable'
  installPlanApproval: Automatic
  name: kiali
  source: community-operators
  sourceNamespace: openshift-marketplace
EOM

#install the Jaeger operator
cat <<EOM | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: jaeger
  namespace: openshift-operators
spec:
  channel: 'stable'
  installPlanApproval: Automatic
  name: jaeger
  source: community-operators
  sourceNamespace: openshift-marketplace
EOM

#todo: wait for operators to deploy

oc new-project istio-system

#wait for crds
for crd in servicemeshcontrolplanes.maistra.io servicemeshmemberrolls.maistra.io kialis.kiali.io jaegers.jaegertracing.io
do
    echo -n "Waiting for $crd ..."
    while ! oc get crd $crd > /dev/null 2>&1
    do
        sleep 2
        echo -n '.'
    done
    echo "done."
done

#wait for service mesh operator deployment
servicemesh_deployment=$(oc get deployment -n openshift-operators -o name 2>/dev/null | grep istio)
while [ "${servicemesh_deployment}" == "" ]
do
    sleep 2
    servicemesh_deployment=$(oc get deployment -n openshift-operators -o name 2>/dev/null | grep istio)
done

#wait for Kiali operator deployment
kiali_deployment=$(oc get deployment -n openshift-operators -o name 2>/dev/null | grep kiali)
while [ "${kiali_deployment}" == "" ]
do
    sleep 2
    kiali_deployment=$(oc get deployment -n openshift-operators -o name 2>/dev/null | grep kiali)
done

#wait for Jaeger operator deployment
jaeger_deployment=$(oc get deployment -n openshift-operators -o name 2>/dev/null | grep jaeger)
while [ "${jaeger_deployment}" == "" ]
do
    sleep 2
    jaeger_deployment=$(oc get deployment -n openshift-operators -o name 2>/dev/null | grep jaeger)
done

echo "Waiting for operator deployments to start..."
for op in ${servicemesh_deployment} ${kiali_deployment} ${jaeger_deployment}
do
    echo -n "Waiting for ${op} to be ready..."
    readyReplicas="0"
    while [ "$?" != "0" -o "$readyReplicas" == "0" ]
    do
        sleep 1
        echo -n '.'
        readyReplicas="$(oc get ${op} -n openshift-operators -o jsonpath='{.status.readyReplicas}' 2> /dev/null)"
    done
    echo "done."
done

echo "Creating the scmp/smmr..."
#create our smcp
cat <<EOM | oc apply -n istio-system -f -
apiVersion: maistra.io/v1
kind: ServiceMeshControlPlane
metadata:
  name: minimal-install
spec:
    template: default
    istio:
        tracing:
            enabled: false
EOM

#create our smmr
cat <<EOM | oc apply -n istio-system -f -
apiVersion: maistra.io/v1
kind: ServiceMeshMemberRoll
metadata:
  name: default
spec:
  members:
EOM

# install bookinfo
echo "Success, deploying bookinfo..."
export BOOKINFO_NS=bookinfo
export CONTROL_PLANE_NS=istio-system
oc new-project ${BOOKINFO_NS}

#wait for smcp to fully install
echo -n "Waiting for smcp to fully install (this will take a few moments) ..."
min_install_smcp=$(oc get smcp -n ${CONTROL_PLANE_NS} minimal-install 2>/dev/null | grep InstallSuccessful)
while [ "${min_install_smcp}" == "" ]
do
    echo -n '.'
    sleep 5
    min_install_smcp=$(oc get smcp -n ${CONTROL_PLANE_NS} minimal-install 2>/dev/null | grep InstallSuccessful)
done
echo "done."

oc -n ${CONTROL_PLANE_NS} patch --type='json' smmr default -p '[{"op": "add", "path": "/spec/members", "value":["'"${BOOKINFO_NS}"'"]}]'
oc -n ${BOOKINFO_NS} apply -f https://raw.githubusercontent.com/Maistra/istio/maistra-1.1/samples/bookinfo/platform/kube/bookinfo.yaml
oc -n ${BOOKINFO_NS} apply -f https://raw.githubusercontent.com/Maistra/istio/maistra-1.1/samples/bookinfo/networking/bookinfo-gateway.yaml
export GATEWAY_URL=$(oc -n ${CONTROL_PLANE_NS} get route istio-ingressgateway -o jsonpath='{.spec.host}')
oc -n ${BOOKINFO_NS} apply -f https://raw.githubusercontent.com/Maistra/istio/maistra-1.1/samples/bookinfo/networking/destination-rule-all.yaml
