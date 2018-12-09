Now, we can leverage existing Kubernetes and OpenShift Resource files. Let's take the [nginx deployment example](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment)
 from the Kubernetes docs.  

 **Note**: *We've modified the resource file slightly as we will be deploying
  on OpenShift.*

 Copy `nginx-deployment.yml` into `example-role/files`:

 `cp nginx-deployment.yml ./example-role/files/`{{execute}}

 ```
 $ cat ./example-role/files/nginx-deployment.yml
 kind: DeploymentConfig
apiVersion: v1
metadata:
  name: nginx-deployment
spec:
  template:
    metadata:
      labels:
        name: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.15.4
          ports:
          - containerPort: 80
  replicas: 3
  selector:
    name: nginx
 ```

 Update `example-role/tasks/main.yml`:

 <pre class="file"
  data-filename="/root/tutorial/example-role/tasks/main.yml"
   data-target="replace">
---
- name: set test namespace to {{ state }}
  k8s:
   api_version: v1
   kind: Namespace
   name: test
   state: "{{ state }}"

- name: set nginx deployment to {{ state }}
  k8s:
   state: "{{ state }}"
   definition: "{{ lookup('file', 'nginx-deployment.yml') }}"
   namespace: test
 </pre>

 Run the playbook:

 `ansible-playbook -i myhosts playbook.yml`{{execute}}

You can see the `test` namespace created and the `nginx` deployment created in the new namespace.

`oc get all -n test`{{execute}}

And just like before we can take it all down by simply running our playbook with `state=absent`:

`ansible-playbook -i myhosts playbook.yml -e state=absent`{{execute}}
