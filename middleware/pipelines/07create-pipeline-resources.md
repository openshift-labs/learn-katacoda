Before we can trigger the pipeline just created, pipeline resources must be defined as inputs and outputs for the build task of the pipeline.

The build task of your pipeline takes a git repository as an input and then produces an image that is pushed to an image registry. Pipeline resources are how you can specify the specific URLs of the git repository and the image registry.

Much like tasks, these pipeline resources are reusable. The git repository pipeline resource could be used as an input to a different task on a different pipeline, and the image registry output could be used for a different image as the result of a task run.

The following pipeline resource defines the git repository and reference for the _nodejs-ex_ application:

```
apiVersion: tekton.dev/v1alpha1
kind: PipelineResource
metadata:
  name: nodejs-ex-git
  labels:
    app: tekton-workshop
spec:
  type: git
  params:
  - name: url
    value: https://github.com/sclorg/nodejs-ex
```

You can see above that the resource has a name (i.e. _nodejs-ex-git_), and, under the spec property, we define that this pipeline resource has a type of git, meaning it is a git repository.

The last property of _nodejs-ex-git_ is params and is used to specify the URL associated with the git input.

The following defines the OpenShift internal registry for the resulting _nodejs-ex_ image to be pushed to:

```
apiVersion: tekton.dev/v1alpha1
kind: PipelineResource
metadata:
  name: nodejs-ex-image
  labels:
    app: tekton-workshop
spec:
  type: image
  params:
  - name: url
    value: image-registry.openshift-image-registry.svc:5000/lab-tekton/nodejs-ex:latest
```

The format follows the same structure as the git pipeline resource. The main difference is that a type of image is specified under the spec property, meaning this is an image registry that will have an image pushed to it. The URL for the registry is specified under the params property, just like with the git pipeline resource. In this case, we are using OpenShift's internal registry.

Create the above pipeline resources via the oc commands below.

Add the git repository input for the pipeline:

`oc create -f resources/git-pipeline-resource.yaml`{{execute}}

Add the registry for the image to be pushed to as an output of the build task of the pipeline:

`oc create -f resources/image-pipeline-resource.yaml`{{execute}}

You can see the pipeline resources created using tkn:

`tkn resource ls`{{execute}}

You can also get more information about the pipeline resources in your OpenShift project using the command below. Run the command below to see information about the _nodejs-ex-git_ pipeline resource:

`tkn resource describe nodejs-ex-git`{{execute}}

You should see the name of the pipeline resource, the Namespace (i.e. your OpenShift project), it has been created in, and a PipelineResource Type of git to specify this is a git repository.

It also shows the URL of the git repository you use under the Params section of the output. Also, notice the section of the output called Secret Params. These secret params are how you can mask sensitive information associated with pipeline resources, such as a password or key.

You can also describe the _nodejs-ex-image_ pipeline resource by running the command below:

`tkn resource describe nodejs-ex-image`{{execute}}

The primary difference you should notice is that _nodejs-ex-image_ is of PipelineResource Type image. You should also notice the OpenShift image registry URL that is specific to the OpenShift project you are working in.

Now that pipeline resources have been specified, you can include these as part of a pipeline run that will deploy the _nodejs-ex_ application out to OpenShift. 