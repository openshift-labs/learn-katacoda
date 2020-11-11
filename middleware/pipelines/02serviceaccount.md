In this workshop, the pipeline you create uses tools such as [s2i](https://github.com/openshift/source-to-image) and [Buildah](https://buildah.io/) to create a container image for an application and build the image.

Building container images using build tools (such as s2i, Buildah, and Kaniko) require privileged access to the cluster. OpenShift Pipelines automatically adds and configures a `ServiceAccount` named `pipeline` that has sufficient permissions to build and push an image. This service account will be used later in the tutorial.

Run the following command to see the `pipeline` service account:

`oc get serviceaccount pipeline`{{execute}}

In the next section, you will set up the sample application on OpenShift that is deployed in this workshop.