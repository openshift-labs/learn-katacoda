Next, we'll use the Ansible k8s module to leverage existing Kubernetes and OpenShift Resource files. Let's take the **[nginx deployment example](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment)**
 from the Kubernetes docs.  

 **Note**: *We've modified the resource file slightly as we will be deploying
  on OpenShift.*

---

 ###### **a. Copy the nginx deployment definition `nginx-deployment.yml` into `example-role/templates`**

 `cp nginx-deployment.yml ./example-role/templates/`{{execute}}

 ```
$ cat ./example-role/templates/nginx-deployment.yml

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
---


 ###### **b. Update tasks file `example-role/tasks/main.yml` to create the nginx deployment using the k8s module**

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
   definition: "{{ lookup('template', 'nginx-deployment.yml') }}"
   namespace: test
 </pre>

---

###### **c. Run the playbook to deploy nginx onto OpenShift**

Running the playbook with the command below will read the `state` variable defined in `example-role/defaults/main.yml`

 `ansible-playbook -i myhosts playbook.yml`{{execute}}

---

###### **d. Examine playbook results**
You can see the `test` namespace created and the `nginx` deployment created in the new namespace.

`oc get all -n test`{{execute}}

---
###### **e. Revert changes made by playbook**

Remove your nginx deployment from OpenShift by running the playbook again.

For this playbook run, we'll override the `state` variable to contain `state=absent` using the [`-e / --extra-vars`](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#passing-variables-on-the-command-line) flag. 

`ansible-playbook -i myhosts playbook.yml --extra-vars state=absent`{{execute}}