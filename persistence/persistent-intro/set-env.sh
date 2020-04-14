launch.sh

#!/bin/bash

set +x

export OCS_IMAGE=quay.io/mulbc/ocs-operator
export REGISTRY_NAMESPACE=mulbc
export IMAGE_TAG=katacoda

oc label "$(oc get no -o name)" cluster.ocs.openshift.io/openshift-storage='' > /dev/null

oc create ns openshift-storage > /dev/null
oc create ns local-storage > /dev/null
oc project openshift-storage > /dev/null

cat <<EOF | oc create -f - > /dev/null
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  annotations:
    olm.providedAPIs: BackingStore.v1alpha1.noobaa.io,BucketClass.v1alpha1.noobaa.io,CephBlockPool.v1.ceph.rook.io,CephCluster.v1.ceph.rook.io,CephNFS.v1.ceph.rook.io,CephObjectStore.v1.ceph.rook.io,CephObjectStoreUser.v1.ceph.rook.io,NooBaa.v1alpha1.noobaa.io,OCSInitialization.v1.ocs.openshift.io,ObjectBucket.v1alpha1.objectbucket.io,ObjectBucketClaim.v1alpha1.objectbucket.io,StorageCluster.v1.ocs.openshift.io,StorageClusterInitialization.v1.ocs.openshift.io
  name: openshift-storage-group
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
  image: quay.io/$REGISTRY_NAMESPACE/ocs-registry:$IMAGE_TAG
  displayName: OpenShift Container Storage
  publisher: Red Hat
EOF

sleep 10s

# Install OCS - needs to wait for CatalogSource to be "checked"
cat <<EOF | oc create -f - > /dev/null
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ocs-operator
  namespace: openshift-storage
spec:
  channel: alpha
  installPlanApproval: Automatic
  name: ocs-operator
  source: ocs-catalogsource
  sourceNamespace: openshift-marketplace
  startingCSV: ocs-operator.v4.3.0
EOF

# LSO install
cat <<EOF | oc create -f - > /dev/null
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  annotations:
    olm.providedAPIs: LocalVolume.v1.local.storage.openshift.io
  generateName: local-storage-
  name: local-storage-qtk96
  namespace: local-storage
spec:
  targetNamespaces:
  - local-storage
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: local-storage-operator
  namespace: local-storage
spec:
  channel: "4.2"
  installPlanApproval: Automatic
  name: local-storage-operator
  source: redhat-operators
  sourceNamespace: openshift-marketplace
  startingCSV: local-storage-operator.4.2.26-202003230335
EOF

echo "Waiting for operators to be ready" && while [ "$(oc get csv --all-namespaces | grep -c Succeeded)" -lt 4 ]; do echo -n . ; sleep 3; done
echo "Operators are ready now"

cat <<EOF | oc create -f - > /dev/null
apiVersion: local.storage.openshift.io/v1
kind: LocalVolume
metadata:
  name: local-block
  namespace: local-storage
spec:
  nodeSelector:
    nodeSelectorTerms:
    - matchExpressions:
        - key: cluster.ocs.openshift.io/openshift-storage
          operator: In
          values:
          - ""
  storageClassDevices:
    - storageClassName: localblock
      volumeMode: Block
      devicePaths:
        - /dev/vdb
        - /dev/vdc
        - /dev/vdd
EOF

seq 20 30 | xargs -n1 -P0 -t -I {} oc patch pv/pv00{} -p '{"metadata":{"annotations":{"volume.beta.kubernetes.io/storage-class": "localfile"}}}'

cat <<EOF | oc create -f - > /dev/null
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

echo "OCS is installing now, please be patient"

curl -s https://raw.githubusercontent.com/rook/rook/release-1.1/cluster/examples/kubernetes/ceph/toolbox.yaml | sed 's/namespace: rook-ceph/namespace: openshift-storage/g'| oc apply -f - > /dev/null
sleep 3
oc wait --for=condition=Ready --timeout=10m pod -l app=rook-ceph-tools
export POD=$(oc get po -l app=rook-ceph-tools -o name)

echo "OCS is installed now"