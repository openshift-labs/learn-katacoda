## Install Tekton Operator

OpenShift Pipelines is provided as an OpenShift add-on that can be installed via an
operator that is available in the OpenShift OperatorHub.

Operators may be installed into a single namespace and only monitor resources in that
namespace, but the OpenShift Pipelines Operator installs globally on the cluster and monitors
and manage pipelines for every single user in the cluster.

You can install the operator using the "Operators" tab in the web console or you can use the CLI tool "oc". In this exercise, we will use the latter.

To install the operator, you will need to be logged in as an admin. You can do so by running

`oc login -u admin -p admin`{{copy}}

Now that you are logged in, you should be able to see the packages available to you to install from the OperatorHub. Let's take a look at the _openshift-pipelines-operator_ one.

`oc describe packagemanifest openshift-pipelines-operator -n openshift-marketplace`{{copy}}


That's it!

In the next step, we'll get started with creating your first project using the **web console**.
