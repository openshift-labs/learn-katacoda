#!/bin/bash

echo "Starting OpenShift Service Mesh install."
echo "Please wait.........................."
echo "Subscribing to the operators..."
#install the elastic operator
cat <<EOM | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: elasticsearch-operator
  namespace: openshift-operators
spec:
  channel: stable
  installPlanApproval: Automatic
  name: elasticsearch-operator
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOM

#install the Kiali operator
cat <<EOM | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: kiali-ossm
  namespace: openshift-operators
spec:
  channel: stable
  installPlanApproval: Automatic
  name: kiali-ossm
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOM

#install the Jaeger operator
cat <<EOM | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: jaeger-product
  namespace: openshift-operators
spec:
  channel: stable
  installPlanApproval: Automatic
  name: jaeger-product
  source: redhat-operators
  sourceNamespace: openshift-marketplace
EOM

#install the ServiceMesh operator
cat <<EOM | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: servicemeshoperator
  namespace: openshift-operators
spec:
  channel: stable
  installPlanApproval: Automatic
  name: servicemeshoperator
  source: redhat-operators
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

#wait for elastic operator deployment
elastic_deployment=$(oc get deployment -n openshift-operators -o name 2>/dev/null | grep elastic)
while [ "${elastic_deployment}" == "" ]
do
    sleep 2
    elastic_deployment=$(oc get deployment -n openshift-operators -o name 2>/dev/null | grep elastic)
done

echo "Waiting for operator deployments to start..."
for op in ${servicemesh_deployment} ${kiali_deployment} ${jaeger_deployment} ${elastic_deployment}
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
apiVersion: maistra.io/v2
kind: ServiceMeshControlPlane
metadata:
  namespace: istio-system
  name: basic
spec:
  tracing:
    sampling: 10000
    type: Jaeger
  policy:
    type: Istiod
  addons:
    grafana:
      enabled: true
    jaeger:
      install:
        storage:
          type: Memory
    kiali:
      enabled: true
    prometheus:
      enabled: true
  version: v2.0
  telemetry:
    type: Istiod
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
basic_install_smcp=$(oc get smcp -n ${CONTROL_PLANE_NS} basic 2>/dev/null | grep ComponentsReady)
while [ "${basic_install_smcp}" == "" ]
do
    echo -n '.'
    sleep 5
    basic_install_smcp=$(oc get smcp -n ${CONTROL_PLANE_NS} basic 2>/dev/null | grep ComponentsReady)
done
echo "done."

oc patch -n ${CONTROL_PLANE_NS} --type='json' smmr default -p '[{"op": "add", "path": "/spec/members", "value":["'"${BOOKINFO_NS}"'"]}]'
oc apply -n ${BOOKINFO_NS} -f https://raw.githubusercontent.com/Maistra/istio/maistra-2.0/samples/bookinfo/platform/kube/bookinfo.yaml
oc apply -n ${BOOKINFO_NS} -f https://raw.githubusercontent.com/Maistra/istio/maistra-2.0/samples/bookinfo/networking/bookinfo-gateway.yaml
export GATEWAY_URL=$(oc get -n ${CONTROL_PLANE_NS} route istio-ingressgateway -o jsonpath='{.spec.host}')
oc apply -n ${BOOKINFO_NS} -f https://raw.githubusercontent.com/Maistra/istio/maistra-2.0/samples/bookinfo/networking/destination-rule-all.yaml
export BOOKINFO_GATEWAY_URL=$(oc get route -n ${CONTROL_PLANE_NS} | grep ${BOOKINFO_NS} | awk -F ' ' '{print $2}')

echo ""
echo ""
echo "Red Hat OpenShift Service Mesh and bookinfo has been deployed!"
echo "Test the bookinfo application out at: http://${BOOKINFO_GATEWAY_URL}/productpage"
echo "Note: It may take a few moments for everything to deploy before the URL above is active."
