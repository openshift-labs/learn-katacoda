OpenShift Pipelines is provided as an OpenShift add-on that can be installed via an
operator that is available in the OpenShift OperatorHub.

Operators may be installed into a single namespace and only monitor resources in that
namespace, but the OpenShift Pipelines Operator installs globally on the cluster and monitors
and manage pipelines for every single user in the cluster.

You can install the operator using the "Operators" tab in the web console or you can use the CLI tool "oc". In this exercise, we will use the latter.

To install the operator, you will need to be logged in as an admin. You can do so by running

`oc login -u admin -p admin`{{execute}}

Now that you are logged in, you should be able to see the packages available to you to install from the OperatorHub. Let's take a look at the _openshift-pipelines-operator_ one.

`oc describe packagemanifest openshift-pipelines-operator -n openshift-marketplace`{{execute}}

You can find more information on how to add operators on the [OpenShift documentation page](https://docs.openshift.com/container-platform/4.2/operators/olm-adding-operators-to-cluster.html). For now, all you need to do is apply the associated YAML file.

`oc apply -f ./operator/subscription.yaml`{{execute}}

## Verify installation

The OpenShift Pipelines Operator provides all its resources under a single API group: tekton.dev. To see all the resources provided by the operator, run the following command:

`oc api-resources --api-group=tekton.dev`{{execute}}

**Note**: It might take a minute before the operator gets applied so you might need to try this command a few times before seeing anything.

## Verify user roles

To validate that your user has been granted the appropriate roles, you can use the oc auth can-i command to see whether you can create Kubernetes custom resources of the kind the OpenShift Pipelines Operator responds to.

The custom resource you need to create an OpenShift Pipelines pipeline is a resource of the kind pipeline.tekton.dev in the tekton.dev API group. To check that you can create this, run:

`oc auth can-i create pipeline.tekton.dev`{{execute}}

Or you can use the simplified version:

`oc auth can-i create Pipeline`{{execute}}

When run, if the response is yes, you have the appropriate access.

Verify that you can create the rest of the Tekton custom resources needed for this workshop by running the commands below. All of the commands should respond with yes.

`oc auth can-i create Task`{{execute}}
`oc auth can-i create PipelineResource`{{execute}}
`oc auth can-i create PipelineRun`{{execute}}

Now that we have verified that you can create the required resources, let’s start the workshop.