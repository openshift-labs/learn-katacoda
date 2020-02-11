In this workshop, the pipeline you create uses tools such as [s2i](https://github.com/openshift/source-to-image) and [Buildah](https://buildah.io/) to create a container image for an application and build the image.

Building container images using build tools (such as s2i, Buildah and Kaniko) require privileged access to the cluster. OpenShift default security settings do not allow access to privileged containers unless correctly configured.

This operator has created a `ServiceAccount` with the required permissions to run privileged pods for building images. The name of this service account is easy to remember. It is named _pipeline_.

You can verify that the pipeline has been created by running the following command:

`oc get serviceaccount pipeline`{{execute}}

In addition to privileged security context constraints (SCC), the _pipeline_ service account also has the edit role. This set of permissions allows _pipeline_ to push a container image to OpenShift's internal image registry.

_pipeline_ is only able to push to a section of OpenShift's internal image registry that corresponds to your OpenShift project namespace. This namespacing helps to separate projects on an OpenShift cluster.

The pipeline service account executes PipelineRuns on your behalf. You can see an explicit reference for a service account when you trigger a pipeline run later in this workshop. 

In the next section, you will set up the sample application on OpenShift that is deployed in this workshop.