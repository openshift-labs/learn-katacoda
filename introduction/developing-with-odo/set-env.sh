~/.launch.sh

export ODO_VERSION="0.0.3"

curl -k -L "https://github.com/redhat-developer/ocdev/releases/download/v${ODO_VERSION}/ocdev-linux-amd64.gz" | gzip -d > /usr/local/bin/ocdev; chmod +x /usr/local/bin/ocdev
echo 'source <(ocdev completion bash)' >> .bashrc

yum install -y maven

git clone https://github.com/marekjelen/katacoda-odo-backend.git backend
git clone https://github.com/marekjelen/katacoda-odo-frontend.git frontend

oc adm policy add-cluster-role-to-user cluster-admin developer

for i in {1..20}; do
cat <<EOF > tmp.json
{
    "apiVersion": "v1",
    "kind": "PersistentVolume",
    "metadata": {
        "name": "pv-${i}"
    },
    "spec": {
        "accessModes": [
            "ReadWriteOnce",
            "ReadWriteMany",
            "ReadOnlyMany"
        ],
        "capacity": {
            "storage": "10Gi"
        },
        "hostPath": {
            "path": "/data/pv-${i}"
        },
        "persistentVolumeReclaimPolicy": "Recycle"
    }
}
EOF
mkdir -p /data/pv-$i
chmod 0777 /data/pv-$i
oc create -f tmp.json
rm tmp.json
done

exec /bin/bash
