Modify `example-role/tasks/main.yml` with desired Ansible logic. For this
example we will create and delete a namespace with the switch of a variable:

**Note:** You must have the target file open and the active tab in the edit pane in order for the
*copy to editor* button to work properly.

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

**note:** *Setting ignore_errors: true is done so that deleting a nonexistent
project doesn't error out.*

Modify `example-role/defaults/main.yml` to set `state` to `present` by default.

<pre class="file"
 data-filename="/root/tutorial/example-role/defaults/main.yml"
  data-target="replace">
---
state: present

</pre>

Run the playbook:

`ansible-playbook -i myhosts playbook.yml`{{execute}}

Check that the namespace was created:


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
