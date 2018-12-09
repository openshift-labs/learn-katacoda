Login to OpenShift as the developer user:

`oc login -u developer -p developer [[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com`{{execute}}

This will log you in using the credentials:

* **Username:** ``developer``
* **Password:** ``developer``

Use the same credentials to log into the web console.

In order that you can still run commands from the command line as a cluster
admin, the ``sudoer`` role has been enabled for the ``developer`` account.
To execute a command as a cluster admin use the ``--as system:admin`` option
to the command.

Before running the operator, Kubernetes needs to know about the new custom
resource definition the operator will be watching.

Deploy the CRD:

`oc create -f deploy/crds/cache_v1alpha1_memcached_crd.yaml --as system:admin`{{execute}}

Once this is done, there are two ways to run the operator:

* As a pod inside an Openshift cluster
* As a go program outside the cluster using operator-sdk

For the sake of this tutorial, we will run the operator as a pod inside of a
Openshift Cluster. If you are interested in learning more about running the
operator using operator-sdk, see the section at the bottom of this document.

### Run as a pod inside an Openshift cluster

Running as a pod inside a Openshift cluster is preferred for production use.

Let's build the memcached-operator image:

`operator-sdk build memcached-operator:v0.0.1`{{execute}}

Rather than use an external registry, for this tutorial we will just push our
image directly to the internal registry of our Openshift cluster.

Next, we need to push the image to the internal registry of our Openshift
cluster.

Step 1: Create a new project

`oc new-project tutorial`{{execute}}

Step 2: Tag your local operator image to the remote registry

`docker tag memcached-operator:v0.0.1 ocp-registry:5000/tutorial/memcached-operator:v0.0.1`{{execute}}

Step 3: Login to internal docker registry

`docker login -u developer -p $(oc whoami -t) -e unused ocp-registry:5000`{{execute}}

Step 4: Push the local operator image to the internal registry

`docker push ocp-registry:5000/tutorial/memcached-operator:v0.0.1`{{execute}}

Kubernetes deployment manifests are generated in `deploy/operator.yaml`. The
deployment image in this file needs to be modified from the placeholder
`REPLACE_IMAGE` to the previously-built image. We also want to modify the default
ImagePullPolicy from `Always` to `Never` since we are not pushing our image to
a registry. To do this run:

`sed -i 's|REPLACE_IMAGE|memcached-operator:v0.0.1|g' deploy/operator.yaml`{{execute}}

`sed -i 's|Always|Never|g' deploy/operator.yaml`{{execute}}

Now, we are ready to deploy the memcached-operator:

Create Service Account
`oc create -f deploy/service_account.yaml`{{execute}}

Create Role
`oc create -f deploy/role.yaml --as system:admin`{{execute}}

Create Role Binding
`oc create -f deploy/role_binding.yaml --as system:admin`{{execute}}

Create Operator<br>
`oc create -f deploy/operator.yaml`{{execute}}

**Note:** *The role.yaml and role_binding.yaml are creating cluster-wide
resources, so require elevated permissions.*

Verify that the memcached-operator is up and running:

`oc get deployment`{{execute}}

<small>
```sh
NAME                DESIRED CURRENT UP-TO-DATE AVAILABLE AGE
memcached-operator  1       1       1          1         1m
```
</small>
