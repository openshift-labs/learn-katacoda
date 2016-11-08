ssh -i ~/.ssh/id_rsa root@host01 "yum install nfs-utils -y"

echo 'apiVersion: v1' >> nfs-0001.yaml
echo 'kind: PersistentVolume' >> nfs-0001.yaml
echo 'metadata:' >> nfs-0001.yaml
echo '  name: nfs-0001' >> nfs-0001.yaml
echo 'spec:' >> nfs-0001.yaml
echo '  capacity:' >> nfs-0001.yaml
echo '    storage: 2Gi' >> nfs-0001.yaml
echo '  accessModes:' >> nfs-0001.yaml
echo '    - ReadWriteOnce' >> nfs-0001.yaml
echo '    - ReadWriteMany' >> nfs-0001.yaml
echo '  persistentVolumeReclaimPolicy: Recycle' >> nfs-0001.yaml
echo '  nfs:' >> nfs-0001.yaml
echo '    server: [[HOST_IP]]' >> nfs-0001.yaml
echo '    path: /exports/data-0001' >> nfs-0001.yaml

echo 'apiVersion: v1' >> nfs-0002.yaml
echo 'kind: PersistentVolume' >> nfs-0002.yaml
echo 'metadata:' >> nfs-0002.yaml
echo '  name: nfs-0002' >> nfs-0002.yaml
echo 'spec:' >> nfs-0002.yaml
echo '  capacity:' >> nfs-0002.yaml
echo '    storage: 5Gi' >> nfs-0002.yaml
echo '  accessModes:' >> nfs-0002.yaml
echo '    - ReadWriteOnce' >> nfs-0002.yaml
echo '    - ReadWriteMany' >> nfs-0002.yaml
echo '  persistentVolumeReclaimPolicy: Recycle' >> nfs-0002.yaml
echo '  nfs:' >> nfs-0002.yaml
echo '    server: [[HOST_IP]]' >> nfs-0002.yaml
echo '    path: /exports/data-0002' >> nfs-0002.yaml

echo 'kind: PersistentVolumeClaim' >> pvc-mysql.yaml
echo 'apiVersion: v1' >> pvc-mysql.yaml
echo 'metadata:' >> pvc-mysql.yaml
echo '  name: claim-mysql' >> pvc-mysql.yaml
echo 'spec:' >> pvc-mysql.yaml
echo '  accessModes:' >> pvc-mysql.yaml
echo '    - ReadWriteOnce' >> pvc-mysql.yaml
echo '  resources:' >> pvc-mysql.yaml
echo '    requests:' >> pvc-mysql.yaml
echo '      storage: 3Gi' >> pvc-mysql.yaml
echo 'kind: PersistentVolumeClaim' >> pvc-http.yaml
echo 'apiVersion: v1' >> pvc-http.yaml
echo 'metadata:' >> pvc-http.yaml
echo '  name: claim-http' >> pvc-http.yaml
echo 'spec:' >> pvc-http.yaml
echo '  accessModes:' >> pvc-http.yaml
echo '    - ReadWriteOnce' >> pvc-http.yaml
echo '  resources:' >> pvc-http.yaml
echo '    requests:' >> pvc-http.yaml
echo '      storage: 1Gi' >> pvc-http.yaml

echo 'apiVersion: v1' >> pod-mysql.yaml
echo 'kind: Pod' >> pod-mysql.yaml
echo 'metadata:' >> pod-mysql.yaml
echo '  name: mysql' >> pod-mysql.yaml
echo '  labels:' >> pod-mysql.yaml
echo '    name: mysql' >> pod-mysql.yaml
echo 'spec:' >> pod-mysql.yaml
echo '  containers:' >> pod-mysql.yaml
echo '  - name: mysql' >> pod-mysql.yaml
echo '    image: openshift/mysql-55-centos7' >> pod-mysql.yaml
echo '    env:' >> pod-mysql.yaml
echo '      - name: MYSQL_ROOT_PASSWORD' >> pod-mysql.yaml
echo '        value: yourpassword' >> pod-mysql.yaml
echo '      - name: MYSQL_USER' >> pod-mysql.yaml
echo '        value: wp_user' >> pod-mysql.yaml
echo '      - name: MYSQL_PASSWORD' >> pod-mysql.yaml
echo '        value: wp_pass' >> pod-mysql.yaml
echo '      - name: MYSQL_DATABASE' >> pod-mysql.yaml
echo '        value: wp_db' >> pod-mysql.yaml
echo '    ports:' >> pod-mysql.yaml
echo '      - containerPort: 3306' >> pod-mysql.yaml
echo '        name: mysql' >> pod-mysql.yaml
echo '    volumeMounts:' >> pod-mysql.yaml
echo '      - name: mysql-persistent-storage' >> pod-mysql.yaml
echo '        mountPath: /var/lib/mysql/data' >> pod-mysql.yaml
echo '  volumes:' >> pod-mysql.yaml
echo '    - name: mysql-persistent-storage' >> pod-mysql.yaml
echo '      persistentVolumeClaim:' >> pod-mysql.yaml
echo '        claimName: claim-mysql' >> pod-mysql.yaml

echo 'apiVersion: v1' >> pod-www.yaml
echo 'kind: Pod' >> pod-www.yaml
echo 'metadata:' >> pod-www.yaml
echo '  name: www' >> pod-www.yaml
echo '  labels:' >> pod-www.yaml
echo '    name: www' >> pod-www.yaml
echo 'spec:' >> pod-www.yaml
echo '  containers:' >> pod-www.yaml
echo '  - name: www' >> pod-www.yaml
echo '    image: nginx:alpine' >> pod-www.yaml
echo '    ports:' >> pod-www.yaml
echo '      - containerPort: 80' >> pod-www.yaml
echo '        name: www' >> pod-www.yaml
echo '    volumeMounts:' >> pod-www.yaml
echo '      - name: www-persistent-storage' >> pod-www.yaml
echo '        mountPath: /usr/share/nginx/html' >> pod-www.yaml
echo '  volumes:' >> pod-www.yaml
echo '    - name: www-persistent-storage' >> pod-www.yaml
echo '      persistentVolumeClaim:' >> pod-www.yaml
echo '        claimName: claim-http' >> pod-www.yaml

scp * root@host01:/root/
