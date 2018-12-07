Thus far, we have created the memcached-operator project specifically for watching the
Memcached resource with APIVersion `cache.example.com/v1apha1` and Kind
`Memcached`.  Now it's time to define the operator logic.

## Customize the operator logic

For this example the memcached-operator will execute the following
reconciliation logic for each `Memcached` Custom Resource (CR):
- Create a memcached Deployment if it doesn't exist
- Ensure that the Deployment size is the same as specified by the `Memcached`
CR

## Installing an existing role from Ansible Galaxy

To speed things up, we can reuse a role that has been written inside of our
operator. The role we will use is
[dymurray.memcached_operator_role][memcached_galaxy]. The section at the bottom
of this document will also show the reader how to create that Ansible Role from
scratch. To get started, install the Ansible Role inside of the project:

`ansible-galaxy install dymurray.memcached_operator_role -p ./roles`{{execute}}

```
$ ls roles/
dymurray.memcached_operator_role Memcached
```
# Delete generated scaffolding role
`rm -rf ./roles/Memcached`{{execute}}

This role provides the user with a variable `size` which is an integer to
control the number of replicas to create. You can find the default for this
variable in the role defaults:

```
$ cat roles/dymurray.memcached_operator_role/defaults/main.yml
---
# defaults file for Memcached
size: 1
```

The reader can also take note of the tasks file which uses the Kubernetes
Ansible module to create a deployment of memcached if it does not exist. Again,
see below for a deep dive into each portion of the role.

It is important that we modify the necessary files to ensure that our operator
is using this role instead of the generated scaffolding role. Let's
modify `watches.yaml`.

### Watches File

By default, the memcached-operator watches `Memcached` resource events as shown
in `watches.yaml` and executes Ansible Role `Memached`. Since we have changed
this role, lets change it to:

<pre class="file"
 data-filename="/root/tutorial/memcached-operator/watches.yaml"
  data-target="replace">
---
- version: v1alpha1
  group: cache.example.com
  kind: Memcached
  role: /opt/ansible/roles/dymurray.memcached_operator_role
</pre>

Now we are ready to build and run.
