OpenShift Pipelines are an OpenShift add-on that can be installed via an operator that is available in the OpenShift OperatorHub.

Operators may be installed into a single namespace and only monitor resources in that namespace. The OpenShift Pipelines Operator installs globally on the cluster and monitors and manages pipelines for every single user in the cluster.

You can install the operator using the "Operators" tab in the web console, or you can use the CLI tool "oc". In this exercise, we use the latter.

To install the operator, you need to log in as an admin. You can do so by running:

`oc login -u admin -p admin`{{execute}}

Now that you have logged in, you should be able to see the packages available to you to install from the OperatorHub. Let's take a look at the _openshift-pipelines-operator_ one.

`oc describe packagemanifest openshift-pipelines-operator -n openshift-marketplace`{{execute}}

From that package manifest, you can find all the information that you need to create a Subscription to the Pipeline Operator.

```
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: openshift-pipelines-operator
  namespace: openshift-operators 
spec:
  channel: dev-preview
  installPlanApproval: Automatic
  name: openshift-pipelines-operator
  source: community-operators 
  sourceNamespace: openshift-marketplace
  startingCSV: openshift-pipelines-operator.v0.8.2
```

The channel, name, starting CSV, source and source namespace are all described in the package file you just described. 

_You can find more information on how to add operators on the [OpenShift documentation page](https://docs.openshift.com/container-platform/latest/operators/olm-adding-operators-to-cluster.html)._

For now, all you need to do is apply the associated YAML file.

`oc apply -f ./operator/subscription.yaml`{{execute}}

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

Once you see the message `Operator ready`, the operator is installed, and you can see the new resources by running: 

`oc api-resources --api-group=tekton.dev`{{execute}}

## Verify user roles

To validate that your user has the appropriate roles, you can use the `oc auth can-i` command to see whether you can create Kubernetes custom resources of the kind needed by the OpenShift Pipelines Operator.

The custom resource you need to create an OpenShift Pipelines pipeline is a resource of the kind pipeline.tekton.dev in the tekton.dev API group. To check that you can create this, run:

`oc auth can-i create pipeline.tekton.dev`{{execute}}

Or you can use the simplified version:

`oc auth can-i create Pipeline`{{execute}}

When run, if the response is yes, you have the appropriate access.

Verify that you can create the rest of the Tekton custom resources needed for this workshop by running the commands below. All of the commands should respond with yes.

`oc auth can-i create Task`{{execute}}
`oc auth can-i create PipelineResource`{{execute}}
`oc auth can-i create PipelineRun`{{execute}}

Now that we have verified that you can create the required resources let's start the workshop.