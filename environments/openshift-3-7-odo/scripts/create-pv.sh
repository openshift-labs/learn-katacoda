#!/bin/bash

cat <<EOF > /tmp/pv.yml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: volname
spec:
  capacity:
    storage: volsize
  accessModes:
    - ReadWriteOnce
    - ReadOnlyMany
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  hostPath:
    path: volpath
EOF

for i in `seq 20`; do
   cat /tmp/pv.yml | sed "s/volname/pv$i/g" | sed "s/volsize/10Gi/g" | sed "s#volpath#/opt/ocp-vol/pv$i#" | oc create -f - --as=system:admin
   mkdir -p "/opt/ocp-vol/pv$i"
   chcon -t svirt_sandbox_file_t "/opt/ocp-vol/pv$i"
   chmod 777 "/opt/ocp-vol/pv$i"
done
