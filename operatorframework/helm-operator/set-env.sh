# Install Helm client
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz
tar -zxvf helm-v2.13.1-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
helm init --client-only

# Setup persistent volumes
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

# Set GOBIN
export GOBIN=/root/tutorial/go/bin

# Install dep
curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

# Switch user to tutorial directory
cd ~/tutorial
