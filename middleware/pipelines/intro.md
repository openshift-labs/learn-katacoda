In this self-paced tutorial, you will learn how to use OpenShift Pipelines to automate the deployment of your applications.

In this tutorial, you will:
* Install the OpenShift Pipelines operator
* Deploy a partial application
* Create reusable Tekton `Tasks`
* Create a Tekton `Pipeline`
* Create `PipelineResources`
* Trigger the created pipeline to finish your application deployment.

## Let's get started

OpenShift Pipelines is a cloud-native, continuous integration and delivery (CI/CD)
solution for building pipelines using [Tekton](https://tekton.dev). Tekton is
a flexible, Kubernetes-native, open-source CI/CD framework that enables automating
deployments across multiple platforms (e.g. Kubernetes, serverless, VMs, and so forth) by
abstracting away the underlying details.

OpenShift Pipelines features:

* Standard CI/CD pipeline definition based on Tekton
* Build container images with tools such as [Source-to-Image (S2I)](https://docs.openshift.com/container-platform/latest/builds/understanding-image-builds.html#build-strategy-s2i_understanding-image-builds) and [Buildah](https://buildah.io/)
* Deploy applications to multiple platforms such as Kubernetes, serverless, and VMs
* Easy to extend and integrate with existing tools
* Scale pipelines on-demand
* Portable across any Kubernetes platform
* Designed for microservices and decentralized teams
* Integrated with the OpenShift Developer Console

## Tekton CRDs

Tekton defines some [Kubernetes custom resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)
as building blocks to standardize pipeline concepts and provide terminology that is consistent across CI/CD solutions. These custom resources are an extension of the Kubernetes API that lets users create and interact with these objects using the OpenShift CLI (`oc`), `kubectl`, and other Kubernetes tools.

The custom resources needed to define a pipeline are listed below:

* `Task`: a reusable, loosely coupled number of steps that perform a specific task (e.g. building a container image)
* `Pipeline`: the definition of the pipeline and the tasks that it should perform
* `PipelineResource`: inputs (e.g. git repository) and outputs (e.g. image registry) to and out of a pipeline or task
* `TaskRun`: the execution and result (i.e. success or failure) of running an instance of a task
* `PipelineRun`: the execution and result (i.e. success or failure) of running a pipeline


In short, to create a pipeline, one does the following:

* Create custom or install [existing](https://github.com/tektoncd/catalog) reusable `Tasks`
* Create a `Pipeline` and `PipelineResources` to define your application's delivery `Pipeline`
* Create a `PipelineRun` to instantiate and invoke the pipeline.

For further details on pipeline concepts, refer to the [Tekton documentation](https://github.com/tektoncd/pipeline/tree/master/docs#learn-more) that provides an excellent guide for understanding various parameters and attributes available for defining pipelines.

In the following sections, you will go through each of the above steps to define and execute a pipeline.

Let's get started!