Next, let's make it possible to customize the replica count for our [nginx deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment)** by adding an `nginx_replicas` variable to the DeploymentConfig template and filling the variable value dynamically with Ansible.

---

###### **a. Modify vars file `example-role/defaults/main.yml`, setting `nginx_replicas: 2`**

<pre class="file"
 data-filename="/root/tutorial/example-role/defaults/main.yml"
  data-target="replace">
---
state: present
nginx_replicas: 2

</pre>

---

###### **b. Modify nginx deployment definition `nginx-deployment.yml.j2` to read `replicas` from the `nginx_replicas` variable**

 <pre class="file"
  data-filename="/root/tutorial/example-role/templates/nginx-deployment.yml.j2"
   data-target="replace">
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
  replicas: "{{ nginx_replicas }}"
  selector:
    name: nginx
 </pre>

---

###### **c. Run the Playbook to change the nginx replica count**

Running the Playbook again will read the variable `nginx_replicas` and use the provided value to customize the nginx DeploymentConfig.

 `ansible-playbook -i myhosts playbook.yml`{{execute}}

---

###### **d. Examine Playbook results**
After running the Playbook, the cluster will scale down one of the nginx pods to meet the new requested replica count of 2. 

`oc get pods -n test`{{execute}}

---
###### **e. Tear down the nginx deployment**

To remove the nginx deployment, we'll override the `state` variable to contain `state=absent` using the [`-e / --extra-vars`](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#passing-variables-on-the-command-line) flag. 

`ansible-playbook -i myhosts playbook.yml --extra-vars state=absent`{{execute}}