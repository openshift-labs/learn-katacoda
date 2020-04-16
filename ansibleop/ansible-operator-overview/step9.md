In order to speed up Operator deployment and testing, `operator-sdk` provides a mechanism to run the Operator outside of a cluster.


## Copying Roles for local development
It is important that the Role path referenced in watches.yaml exists on
your machine. 

We previously ran our Ansible Operator from a container where the Role was
copied to a known location specified by the Dockerfile.

To run our Operator locally, we will manually copy any Roles used by our Operator to a configured Ansible
Roles path for our local machine (e.g /etc/ansible/roles).

`cp -r ~/tutorial/memcached-operator/roles/dymurray.memcached_operator_role /opt/ansible/roles/`{{execute}}

## Running with 'operator-sdk up local'

### Sample Commands
Running `operator-sdk up local` to run an Operator locally requires a KUBECONFIG value to connect with a cluster. Some sample commands are shown below.
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

`oc create -f deploy/crds/cache_v1alpha1_memcached_cr.yaml`{{execute}}

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

`oc delete -f deploy/crds/cache_v1alpha1_memcached_cr.yaml`{{execute}}

`oc delete -f deploy/role_binding.yaml`{{execute}}

`oc delete -f deploy/role.yaml`{{execute}}

`oc delete -f deploy/service_account.yaml`{{execute}}

`oc delete -f deploy/crds/cache_v1alpha1_memcached_crd.yaml`{{execute}}
