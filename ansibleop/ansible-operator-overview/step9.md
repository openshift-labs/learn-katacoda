In order to speed up deployment and testing, the SDK provides a mechanism to run
the Operator outside of a cluster. This method is preferred during the
development cycle to speed up deployment and testing.


## Copying Roles for local development
It is important that the Role path referenced in watches.yaml exists on
your machine. Since we are normally used to using a container where the Role is
put on disk for us, we need to manually copy our Role to the configured Ansible
Roles path (e.g /etc/ansible/roles).

`cp -r ~/tutorial/memcached-operator/roles/dymurray.memcached_operator_role /opt/ansible/roles/`{{execute}}

## Running with 'operator-sdk up local'

### Sample Commands
Running `operator-sdk up local` to run an Operator locally requires a KUBECONFIG value to connect with the cluster. Some sample commands are shown below.
```sh
$ operator-sdk up local # default, KUBECONFIG=$HOME/.kube/config
```
```sh
$ operator-sdk up local --kubeconfig=/tmp/config # KUBECONFIG='/tmp/config'
```

For this scenario, there is a properly permissioned KUBECONFIG at ~/backup/.kube/config.  We'll run the command below to use it.

### Start the Operator
`operator-sdk up local --kubeconfig=/root/backup/.kube/config --namespace tutorial`{{execute}}

Next open a 2nd terminal window, using the "+" tab and navigate to our Operator.

`cd ~/tutorial/memcached-operator`{{execute}}

### Create the Custom Resource

Create the example Memcached CR that was generated at deploy/crds/cache_v1alpha1_memcached_cr.yaml:

`oc create -f deploy/crds/cache_v1alpha1_memcached_cr.yaml --as system:admin`{{execute}}

Ensure that the memcached-operator creates the deployment for the CR:

<small>
```sh
$ oc get deployment
NAME               DESIRED CURRENT UP-TO-DATE AVAILABLE AGE
example-memcached  4       4       4          4         34s
```
</small>

Check the pods to confirm 4 replicas were created:

<small>
```sh
$ oc get pods
NAME                               READY STATUS   RESTARTS AGE
example-memcached-6cc844747c-dp8sx 1/1   Running  0        1m
example-memcached-6cc844747c-hk52c 1/1   Running  0        1m
example-memcached-6cc844747c-q75m4 1/1   Running  0        1m
example-memcached-6cc844747c-xp8qp 1/1   Running  0        1m
```
</small>

### Cleanup

Clean up the resources:

`oc delete -f deploy/crds/cache_v1alpha1_memcached_cr.yaml --as system:admin`{{execute}}

`oc delete -f deploy/role_binding.yaml`{{execute}}

`oc delete -f deploy/role.yaml`{{execute}}

`oc delete -f deploy/service_account.yaml`{{execute}}

`oc delete -f deploy/crds/cache_v1alpha1_memcached_crd.yaml --as system:admin`{{execute}}
