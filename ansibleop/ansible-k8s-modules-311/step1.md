For this example we will *create and delete a namespace* with the switch of an Ansible variable.

---

###### **a. Modify tasks file `example-role/tasks/main.yml` to contain the Ansible shown below.**
<pre class="file" data-filename="/root/tutorial/example-role/tasks/main.yml" data-target="replace">
---
- name: set test namespace to {{ state }}
  k8s:
    api_version: v1
    kind: Namespace
    name: test
    state: "{{ state }}"
  ignore_errors: true

</pre>

**Notes:** 
 - You *must* have the target file open and the active tab in the edit pane in order for the *'Copy to Editor'* button to work properly.
 - Set *'ignore_errors: true'* so that attempting deletion of a nonexistent
project doesn't error out.

---

###### **b. Modify vars file `example-role/defaults/main.yml`, setting `state: present` by default.**

<pre class="file"
 data-filename="/root/tutorial/example-role/defaults/main.yml"
  data-target="replace">
---
state: present

</pre>

---

###### **c. Run playbook.yml, which will execute 'example-role'.**

`ansible-playbook -i myhosts playbook.yml`{{execute}}

---

###### **d. Check that the namespace `test` was created.**

$ `oc get projects`{{execute}}

```
NAME              DISPLAY NAME   STATUS
default                          Active
kube-public                      Active
kube-system                      Active
openshift                        Active
openshift-infra                  Active
test                             Active
```
