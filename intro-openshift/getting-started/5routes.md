OpenShift CLI is accessed using the command _oc_. From here, you can administrate the entire OpenShift cluster and deploy new applications.

The CLI exposes the underlying technology of Kubernetes with the enhancements made by OpenShift. Users familiar with Kubernetes will be able to adopt OpenShift quickly. The CLI is ideal in situations where you are:

1) Working directly with project source code.

2) Scripting OpenShift operations.

3) Restricted by bandwidth resources and cannot use the web console.

## Task

The command _new-app_ deploys an application onto an OpenShift cluster.

The application can either be source code or as in this case, an existing Docker Image like _katacoda/docker-http-server:openshift-v1_. This image is an HTTP server that returns with the hostname of the container processing the request. The application is accessed a more friendly name of _ws-app1_.

Execute the command below to create and deploy the new application.

`oc new-app katacoda/docker-http-server:openshift-v1 --name=ws-app1`{{execute}}

In the next step, we'll verify and view the status of the deployment.
