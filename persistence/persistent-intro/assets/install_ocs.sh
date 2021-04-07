#!/bin/bash

set +x

curl -sL "https://katacoda.blum.coffee/track?id=$(hostname)&lab=intro&action=start" >/dev/null

echo "Setting up environment for ODF - this will take a few minutes"

oc label "$(oc get no -o name)" cluster.ocs.openshift.io/openshift-storage='' >/dev/null

oc create ns openshift-storage >/dev/null
oc project openshift-storage >/dev/null

cat <<EOF | oc create -f - >/dev/null
apiVersion: operators.coreos.com/v1alpha2
kind: OperatorGroup
metadata:
  name: openshift-storage-operatorgroup
  namespace: openshift-storage
spec:
  targetNamespaces:
  - openshift-storage
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: ocs-catalogsource
  namespace: openshift-marketplace
spec:
  sourceType: grpc
  image: quay.io/mulbc/ocs-operator-index:katacoda-46
  displayName: OpenShift Container Storage
  publisher: Red Hat
EOF

sleep 10

cat <<EOF | oc create -f -
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ocs-subscription
  namespace: openshift-storage
spec:
  channel: alpha
  name: ocs-operator
  source: ocs-catalogsource
  sourceNamespace: openshift-marketplace
EOF

echo "Waiting for operators to be ready"
while [ "$(oc get csv -n openshift-storage | grep -c Succeeded)" -lt 1 ]; do
  echo -n .

  cat <<EOF | oc create -f - >/dev/null 2>&1
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ocs-subscription
  namespace: openshift-storage
spec:
  channel: alpha
  name: ocs-operator
  source: ocs-catalogsource
  sourceNamespace: openshift-marketplace
EOF
  sleep 3
done

curl -sL "https://katacoda.blum.coffee/track?id=$(hostname)&lab=intro&action=operators" >/dev/null
echo "Operators are ready now"

cat <<EOF | oc create -f - >/dev/null
---
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: localblock
provisioner: kubernetes.io/no-provisioner
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: local-pv-vdb
spec:
  capacity:
    storage: 20Gi
  volumeMode: Block
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete
  storageClassName: localblock
  local:
    path: /dev/vdb
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: node.openshift.io/os_id
          operator: In
          values:
          - rhcos
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: local-pv-vdc
spec:
  capacity:
    storage: 20Gi
  volumeMode: Block
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete
  storageClassName: localblock
  local:
    path: /dev/vdc
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: node.openshift.io/os_id
          operator: In
          values:
          - rhcos
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: local-pv-vdd
spec:
  capacity:
    storage: 20Gi
  volumeMode: Block
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete
  storageClassName: localblock
  local:
    path: /dev/vdd
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: node.openshift.io/os_id
          operator: In
          values:
          - rhcos
EOF

seq 20 30 | xargs -n1 -P0 -I {} oc patch pv/pv00{} -p '{"metadata":{"annotations":{"volume.beta.kubernetes.io/storage-class": "localfile"}}}' >/dev/null

echo "Finished up preparing the local storage"

cat <<EOF | oc create -f - >/dev/null
apiVersion: ocs.openshift.io/v1
kind: StorageCluster
metadata:
  name: ocs-storagecluster
  namespace: openshift-storage
spec:
  manageNodes: false
  monPVCTemplate:
    spec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 1
      storageClassName: localfile
      volumeMode: Filesystem
  storageDeviceSets:
  - count: 1
    dataPVCTemplate:
      spec:
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: 1
        storageClassName: localblock
        volumeMode: Block
    name: ocs-deviceset
    placement: {}
    portable: false
    replica: 1
    resources: {}
EOF

echo "ODF is installing now, please be patient"

oc patch OCSInitialization ocsinit -n openshift-storage --type json --patch '[{ "op": "replace", "path": "/spec/enableCephTools", "value": true }]'
sleep 3
oc wait --for=condition=Ready --timeout=10m pod -l app=rook-ceph-tools
export POD=$(oc get po -l app=rook-ceph-tools -o name)

echo "ODF is installed now"
curl -sL "https://katacoda.blum.coffee/track?id=$(hostname)&lab=intro&action=provisioning" >/dev/null
