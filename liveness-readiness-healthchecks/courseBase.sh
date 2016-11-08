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
