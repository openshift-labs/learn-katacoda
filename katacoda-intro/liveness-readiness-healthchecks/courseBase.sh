ssh -i ~/.ssh/id_rsa root@host01 "/root/.set-hostname && rm -rf /openshift.local* && /var/lib/openshift/openshift start --write-config /openshift.local.config/ && sed -i 's/masterPublicURL.*/masterPublicURL: https:\/\/[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com:443/g' /openshift.local.config/master/master-config.yaml && sed -i s/router\.default\.svc\.cluster\.local/[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/g /openshift.local.config/master/master-config.yaml && sed -i 's/assetPublicURL.*/assetPublicURL: https:\/\/[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com:443\/console\//g' /openshift.local.config/master/master-config.yaml && sed -i 's/publicURL.*/publicURL: https:\/\/[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com:443\/console\//g' /openshift.local.config/master/master-config.yaml && systemctl restart origin"
echo 'kind: List' >> ~/tutorial/deploy.yaml
echo 'apiVersion: v1' >> ~/tutorial/deploy.yaml
echo 'items:' >> ~/tutorial/deploy.yaml
echo '- kind: ReplicationController' >> ~/tutorial/deploy.yaml
echo '  apiVersion: v1' >> ~/tutorial/deploy.yaml
echo '  metadata:' >> ~/tutorial/deploy.yaml
echo '    name: frontend' >> ~/tutorial/deploy.yaml
echo '    labels:' >> ~/tutorial/deploy.yaml
echo '      name: frontend' >> ~/tutorial/deploy.yaml
echo '  spec:' >> ~/tutorial/deploy.yaml
echo '    replicas: 1' >> ~/tutorial/deploy.yaml
echo '    selector:' >> ~/tutorial/deploy.yaml
echo '      name: frontend' >> ~/tutorial/deploy.yaml
echo '    template:' >> ~/tutorial/deploy.yaml
echo '      metadata:' >> ~/tutorial/deploy.yaml
echo '        labels:' >> ~/tutorial/deploy.yaml
echo '          name: frontend' >> ~/tutorial/deploy.yaml
echo '      spec:' >> ~/tutorial/deploy.yaml
echo '        containers:' >> ~/tutorial/deploy.yaml
echo '        - name: frontend' >> ~/tutorial/deploy.yaml
echo '          image: katacoda/docker-http-server:openshift-healthy' >> ~/tutorial/deploy.yaml
echo '- kind: ReplicationController' >> ~/tutorial/deploy.yaml
echo '  apiVersion: v1' >> ~/tutorial/deploy.yaml
echo '  metadata:' >> ~/tutorial/deploy.yaml
echo '    name: bad-frontend' >> ~/tutorial/deploy.yaml
echo '    labels:' >> ~/tutorial/deploy.yaml
echo '      name: bad-frontend' >> ~/tutorial/deploy.yaml
echo '  spec:' >> ~/tutorial/deploy.yaml
echo '    replicas: 1' >> ~/tutorial/deploy.yaml
echo '    selector:' >> ~/tutorial/deploy.yaml
echo '      name: bad-frontend' >> ~/tutorial/deploy.yaml
echo '    template:' >> ~/tutorial/deploy.yaml
echo '      metadata:' >> ~/tutorial/deploy.yaml
echo '        labels:' >> ~/tutorial/deploy.yaml
echo '          name: bad-frontend' >> ~/tutorial/deploy.yaml
echo '      spec:' >> ~/tutorial/deploy.yaml
echo '        containers:' >> ~/tutorial/deploy.yaml
echo '        - name: bad-frontend' >> ~/tutorial/deploy.yaml
echo '          image: katacoda/docker-http-server:openshift-unhealthy' >> ~/tutorial/deploy.yaml
echo '- kind: Service' >> ~/tutorial/deploy.yaml
echo '  apiVersion: v1' >> ~/tutorial/deploy.yaml
echo '  metadata:' >> ~/tutorial/deploy.yaml
echo '    labels:' >> ~/tutorial/deploy.yaml
echo '      app: frontend' >> ~/tutorial/deploy.yaml
echo '      kubernetes.io/cluster-service: "true"' >> ~/tutorial/deploy.yaml
echo '    name: frontend' >> ~/tutorial/deploy.yaml
echo '  spec:' >> ~/tutorial/deploy.yaml
echo '    type: NodePort' >> ~/tutorial/deploy.yaml
echo '    ports:' >> ~/tutorial/deploy.yaml
echo '    - port: 8080' >> ~/tutorial/deploy.yaml
echo '      nodePort: 30080' >> ~/tutorial/deploy.yaml
echo '    selector:' >> ~/tutorial/deploy.yaml
echo '      app: frontend' >> ~/tutorial/deploy.yaml
echo '- kind: Service' >> ~/tutorial/deploy.yaml
echo '  apiVersion: v1' >> ~/tutorial/deploy.yaml
echo '  metadata:' >> ~/tutorial/deploy.yaml
echo '    labels:' >> ~/tutorial/deploy.yaml
echo '      app: bad-frontend' >> ~/tutorial/deploy.yaml
echo '      kubernetes.io/cluster-service: "true"' >> ~/tutorial/deploy.yaml
echo '    name: bad-frontend' >> ~/tutorial/deploy.yaml
echo '  spec:' >> ~/tutorial/deploy.yaml
echo '    type: NodePort' >> ~/tutorial/deploy.yaml
echo '    ports:' >> ~/tutorial/deploy.yaml
echo '    - port: 8080' >> ~/tutorial/deploy.yaml
echo '      nodePort: 30081' >> ~/tutorial/deploy.yaml
echo '    selector:' >> ~/tutorial/deploy.yaml
echo '      app: bad-frontend' >> ~/tutorial/deploy.yaml
scp ~/tutorial/deploy.yaml root@host01:/root/
