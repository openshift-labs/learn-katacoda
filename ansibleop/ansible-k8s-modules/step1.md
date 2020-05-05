For this example we will *create and delete a namespace* with the switch of an Ansible variable.

---

###### **a. Modify tasks file `example-role/tasks/main.yml` to contain the Ansible shown below.**
<pre class="file">
---
- name: set test namespace to {{ state }}
  k8s:
    api_version: v1
    kind: Namespace
    name: test
    state: "{{ state }}"
  ignore_errors: true

</pre>

You can easily update this file by running the following command:

`wget -q https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/ansibleop/ansible-k8s-modules/assets/tasksmain1.yml -O /root/tutorial/example-role/tasks/main.yml`{{execute}}
<br>
---

###### **b. Modify vars file `example-role/defaults/main.yml`, setting `state: present` by default.**

<pre class="file">
---
state: present

</pre>

You can easily update this file by running the following command:

`wget -q https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/ansibleop/ansible-k8s-modules/assets/defaultsmain1.yml -O /root/tutorial/example-role/defaults/main.yml`{{execute}}
<br>
---

###### **c. Run playbook.yml, which will execute 'example-role'.**

`ansible-playbook -i myhosts playbook.yml`{{execute}}

---

###### **d. Check that the namespace `test` was created.**

$ `oc get projects | grep test`{{execute}}

```
NAME              DISPLAY NAME   STATUS
test                             Active
```
