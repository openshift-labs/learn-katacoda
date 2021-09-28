OpenShift Pipelines are an OpenShift add-on that can be installed via an operator that is available in the OpenShift OperatorHub.

You can either install the operator using the OpenShift Pipelines Operator in the web console or by using the CLI tool `oc`. Let's log in to our cluster to make changes and install the operator. You can do so by running:

`oc login -u admin -p admin`{{execute}}

This will log you in using the credentials:

* **Username:** ``admin``
* **Password:** ``admin``

## Installing the OpenShift Pipelines Operator in Web Console

You can install OpenShift Pipelines using the Operator listed in the OpenShift Container Platform OperatorHub. When you install the OpenShift Pipelines Operator, the Custom Resources (CRs) required for the Pipelines configuration are automatically installed along with the Operator.

Firstly, switch to the _Console_ and login to the OpenShift web console using the same credentials you used above.

![Web Console Login](../../assets/middleware/pipelines/web-console-login.png)

In the _Administrator_ perspective of the web console, navigate to Operators → OperatorHub. You can see the list of available operators for OpenShift provided by Red Hat as well as a community of partners and open-source projects.

Use the _Filter by keyword_ box to search for `OpenShift Pipelines Operator` in the catalog. Click the _OpenShift Pipelines Operator_ tile.

![Web Console Hub](../../assets/middleware/pipelines/web-console-hub.png)

Read the brief description of the Operator on the _OpenShift Pipelines Operator_ page. Click _Install_.

Select _All namespaces on the cluster (default)_ for installation mode & _Automatic_ for the approval strategy. Click Subscribe!

![Web Console Login](../../assets/middleware/pipelines/web-console-settings.png)

Be sure to verify that the OpenShift Pipelines Operator has installed through the Operators → Installed Operators page.

## Installing the OpenShift Pipelines Operator using the CLI

You can install OpenShift Pipelines Operator from the OperatorHub using the CLI.

First, you'll want to create a Subscription object YAML file to subscribe a namespace to the OpenShift Pipelines Operator, for example, `subscription.yaml` as shown below:

```
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: openshift-pipelines-operator
  namespace: openshift-operators 
spec:
  channel: stable
  name: openshift-pipelines-operator-rh
  source: redhat-operators
  sourceNamespace: openshift-marketplace
```

This YAML file defines various components, such as the `channel` specifying the channel name where we want to subscribe, `name` being the name of our Operator, and `source` being the CatalogSource that provides the operator. For your convenience, we've placed this exact file in your `/operator` local folder. 

You can now create the Subscription object similar to any OpenShift object.

`oc apply -f operator/subscription.yaml`{{execute}}

## Verify installation

The OpenShift Pipelines Operator provides all its resources under a single API group: tekton.dev. This operation can take a few seconds; you can run the following script to monitor the progress of the installation.

```
until oc api-resources --api-group=tekton.dev | grep tekton.dev &> /dev/null
do 
 echo "Operator installation in progress..."
 sleep 5
done

echo "Operator ready"
```{{execute}}

Great! The OpenShift Pipelines Operator is now installed. Now, let's start the workshop.
