In this workshop, the pipeline you create will use tools such as [s2i](https://github.com/openshift/source-to-image) and [Buildah](https://buildah.io/) to create a container image for an application and build the image.

Building container images using build tools such as s2i, Buildah, Kaniko, etc. require privileged access to the cluster. OpenShift default security settings do not allow access to privileged containers unless specifically configured.

This workshop has created a ServiceAccount with the required permissions to run privileged pods for building images. The name of this service account is easy to remember. It is named pipeline.

You can verify that pipeline has been created by running the following command:

`oc get serviceaccount pipeline`{{execute}}

In addition to privileged security context constraints (SCC), the pipeline service account also has the edit role. This will allow _pipeline_ to push a container image to OpenShift’s internal image registry.

_pipeline_ will only be able to push to a section of OpenShift’s internal image registry that corresponds to your OpenShift project namespace. This helps to separate projects on an OpenShift cluster.

The pipeline service account will execute PipelineRuns on your behalf. You will see an explicit reference for a service account when you trigger a pipeline run later in this workshop. This is how you will connect the pipeline service account to the pipeline run.

In the next section, you will set up the sample application on OpenShift that will be deployed in this workshop.