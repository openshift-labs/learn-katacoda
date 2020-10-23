## Copying Roles for local development
It is important that the Role path referenced in watches.yaml exists on
your machine. 

To run our Operator locally, we will manually copy any Roles used by our Operator to a configured Ansible
Roles path for our local machine (e.g /etc/ansible/roles).

```
mkdir -p /opt/ansible/roles
cp -r ~/tutorial/memcached-operator/roles/dymurray.memcached_operator_role /opt/ansible/roles/```{{execute}}

## Running with 'operator-sdk run --local'

### Sample Commands
Running `make run` to run an Operator locally requires a KUBECONFIG value to connect with a cluster. A sample command is shown below.

Automatically sets KUBECONFIG=$HOME/.kube/config
```sh
$ make run
```

For this scenario, we will create a new namespace/project called `tutorial`. We will then start up our Operator and ensure our operator only watches for Custom Resources within this namespace.


### Create the Namespace/Project
`oc new-project tutorial`{{execute}}

### Start the Operator and set the WATCH_NAMESPACE variable 
`WATCH_NAMESPACE=tutorial make run`{{execute}}

Next open a 2nd terminal window, using the "+" tab and navigate to our Operator.

`cd ~/tutorial/memcached-operator`{{execute}}


Now that our Operator is running, let's create a CR and deploy an instance
of memcached.

There is a sample CR in the scaffolding created as part of the Operator SDK:

```yaml
apiVersion: cache.example.com/v1alpha1
kind: Memcached
metadata:
  name: memcached-sample
spec:
  foo: bar
```

## Create a Memcached CR instance

Inspect `config/samples/cache_v1alpha1_memcached.yaml`, and then update the object to specify 3 replicas:

```yaml
apiVersion: cache.example.com/v1alpha1
kind: Memcached
metadata:
  name: memcached-sample
spec:
  size: 3
```

Update this file by running the following command:

```
\cp /tmp/cache_v1alpha1_memcached.yaml config/samples/cache_v1alpha1_memcached.yaml
```{{execute}}
<br>

`oc --namespace tutorial create -f config/samples/cache_v1alpha1_memcached.yaml`{{execute}}

## Check that the Memcached Operator works as intended

Ensure that the memcached-operator creates the deployment for the CR:

```oc get deployment```{{execute}}

Check the pods to confirm 3 replicas were created:

```oc get pods```{{execute}}

## Change the Memcached CR to deploy 4 replicas

Change the `spec.size` field in `config/samples/cache_v1alpha1_memcached.yaml` from 3 to 4.

<pre class="file">
apiVersion: cache.example.com/v1alpha1
kind: Memcached
metadata:
  name: memcached-sample
spec:
  size: 4
</pre>

`oc --namespace tutorial apply -f config/samples/cache_v1alpha1_memcached.yaml`{{execute}}

Confirm that the Operator changes the Deployment size:

```oc get deployment```{{execute}}

Inspect the YAML list of 'memcached' resources in your project, noting that the 'spec.size' field is now set to 4.

`oc get memcached  -o yaml`{{execute}}

## Removing Memcached from the cluster 

First, delete the 'memcached' CR, which will remove the 4 Memcached Pods and the associated Deployment.

`oc --namespace tutorial delete -f config/samples/cache_v1alpha1_memcached.yaml`{{execute}}

Verify the memcached CR and deployment have been properly removed.

`oc get memcached`{{execute}}

`oc get deployment`{{execute}}
