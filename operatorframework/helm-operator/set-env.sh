for num in {01..03}; do mkdir -p /tmp/pv$num; done;
for num in {01..03}; do
cat > pv$num.yaml <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: local-pv$num
spec:
  capacity:
    storage: 10Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:
    path: /tmp/pv$num
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - master
EOF
oc apply -f pv$num.yaml; done;
export GOBIN=/root/tutorial/go/bin
curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
#switch user to tutorial directory
cd ~/tutorial
