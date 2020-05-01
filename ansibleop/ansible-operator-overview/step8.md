## Copying Roles for local development
It is important that the Role path referenced in watches.yaml exists on
your machine. 

To run our Operator locally, we will manually copy any Roles used by our Operator to a configured Ansible
Roles path for our local machine (e.g /etc/ansible/roles).

`cp -r ~/tutorial/memcached-operator/roles/dymurray.memcached_operator_role /opt/ansible/roles/`{{execute}}

## Running with 'operator-sdk run --local'

### Sample Commands
Running `operator-sdk run --local` to run an Operator locally requires a KUBECONFIG value to connect with a cluster. Some sample commands are shown below.
```sh
$ operator-sdk run --local # default, KUBECONFIG=$HOME/.kube/config
```
```sh
$ operator-sdk run --local --kubeconfig=/tmp/config # KUBECONFIG='/tmp/config'
```

For this scenario, there is a properly permissioned KUBECONFIG at ~/backup/.kube/config.  We'll run the command below to use it.

### Start the Operator
`operator-sdk run --local --kubeconfig=/root/backup/.kube/config --namespace tutorial`{{execute}}

Next open a 2nd terminal window, using the "+" tab and navigate to our Operator.

`cd ~/tutorial/memcached-operator`{{execute}}


Now that our Operator is running, let's create a CR and deploy an instance
of memcached.

There is a sample CR in the scaffolding created as part of the Operator SDK:

```YAML
apiVersion: cache.example.com/v1alpha1
kind: Memcached
metadata:
  name: example-memcached
spec:
  # Add fields here
  size: 3
```

Let's go ahead and apply this in our Tutorial project to deploy 3 memcached pods,
using our Operator:

## Create a Memcached CR instance

Inspect `deploy/crds/cache_v1alpha1_memcached_cr.yaml`, and then use it to create a `Memcached` custom resource:

```yaml
# deploy/crds/cache_v1alpha1_memcached_cr.yaml
apiVersion: cache.example.com/v1alpha1
kind: Memcached
metadata:
  name: example-memcached
spec:
  size: 3
```

`oc create -f deploy/crds/cache_v1alpha1_memcached_cr.yaml`{{execute}}

## Check that the Memcached Operator works as intended 
Ensure that the memcached-operator creates the deployment for the CR:

<small>
```sh
$ oc get deployment
NAME                 DESIRED CURRENT UP-TO-DATE AVAILABLE AGE
example-memcached    3       3       3          3         1m
```
</small>

Check the pods to confirm 3 replicas were created:

<small>
```sh
$ oc get pods
NAME                                READY STATUS   RESTARTS AGE
example-memcached-6cc844747c-2hbln  1/1   Running  0        1m
example-memcached-6cc844747c-54q26  1/1   Running  0        1m
example-memcached-6cc844747c-7jfhc  1/1   Running  0        1m
```
</small>

## Change the Memcached CR to deploy 4 replicas

Change the `spec.size` field in `deploy/crds/cache_v1alpha1_memcached_cr.yaml` from 3 to 4.

<pre class="file">
apiVersion: cache.example.com/v1alpha1
kind: Memcached
metadata:
  name: example-memcached
spec:
  size: 4
</pre>

Update this file by running the following command:

```
wget -q https://raw.githubusercontent.com/openshift-labs/learn-katacoda/master/ansibleop/ansible-operator-overview/assets/cache_v1alpha1_memcached_cr_updated.yaml -O /root/tutorial/memcached-operator/deploy/crds/cache_v1alpha1_memcached_cr.yaml
```{{execute}}
<br>
Apply the change:

`oc apply -f deploy/crds/cache_v1alpha1_memcached_cr.yaml`{{execute}}

Confirm that the Operator changes the Deployment size:

<small>
```sh
$ oc get deployment
NAME                DESIRED CURRENT  UP-TO-DATE  AVAILABLE  AGE
example-memcached   4       4        4           4          53s```
</small>

Inspect the YAML list of 'memcached' resources in your project, noting that the 'spec.size' field is now set to 4.

`oc get memcached  -o yaml`{{execute}}

## Removing Memcached from the cluster 

First, delete the 'memcached' CR, which will remove the 4 Memcached Pods and the associated Deployment.

`oc delete -f deploy/crds/cache_v1alpha1_memcached_cr.yaml`{{execute}}

<small>
```sh