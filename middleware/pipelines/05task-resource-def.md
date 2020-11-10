You'll be installing the `apply-manifests` and `update-deployment` tasks from the repository using `oc`, which you will need for creating a pipeline in the next section.

The `apply-manifests` task you will create is shown below:

```
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: apply-manifests
spec:
  workspaces:
  - name: source
  params:
    - name: manifest_dir
      description: The directory in source that contains yaml manifests
      type: string
      default: "k8s"
  steps:
    - name: apply
      image: quay.io/openshift/origin-cli:latest
      workingDir: /workspace/source
      command: ["/bin/bash", "-c"]
      args:
        - |-
          echo Applying manifests in $(inputs.params.manifest_dir) directory
          oc apply -f $(inputs.params.manifest_dir)
          echo -----------------------------------
```

In addition, the `apply-manifests` task is shown below:

```
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: update-deployment
spec:
  params:
    - name: deployment
      description: The name of the deployment patch the image
      type: string
    - name: IMAGE
      description: Location of image to be patched with
      type: string
  steps:
    - name: patch
      image: quay.io/openshift/origin-cli:latest
      command: ["/bin/bash", "-c"]
      args:
        - |-
          oc patch deployment $(inputs.params.deployment) --patch='{"spec":{"template":{"spec":{
            "containers":[{
              "name": "$(inputs.params.deployment)",
              "image":"$(inputs.params.IMAGE)"
            }]
          }}}}'
```

_openshift-client_ doesn't have any inputs or outputs associated with it. It also only has one step named oc.

This step uses an image with oc installed and runs the oc root command along with any args passed to the step under the args property. This task allows you to run any command with oc. You will use it to deploy the image created by the _s2i-nodejs_ task to OpenShift. You will see how this takes place in the next section.

Create the _openshift-client_ task that will deploy the image created by _s2i-nodejs_ as a container on OpenShift:

Create the `apply-manifests` and `update-deployment` tasks:

`oc create -f tasks/apply_manifest_task.yaml`{{execute}}
`oc create -f tasks/update_deployment_task.yaml`{{execute}}

**Note**: For convenience, the tasks have been copied from their original locations in the Tekton and OpenShift catalogue git repositories to the workshop.

You can take a look at the tasks you created using the [Tekton CLI](https://github.com/tektoncd/cli/releases):

`tkn task ls`{{execute}}

You should see similar output to this:

```
NAME                AGE
apply-manifests     10 seconds ago
update-deployment   4 seconds ago
```

We will be using `buildah` clusterTasks, which gets installed along with Operator. Operator installs few ClusterTask which you can see.

```
$ tkn clustertasks ls
NAME                       DESCRIPTION   AGE
buildah                                  1 day ago
buildah-v0-14-3                          1 day ago
git-clone                                1 day ago
s2i-php                                  1 day ago
tkn                                      1 day ago
```

In the next section, you will create a pipeline that takes the source code of the application from GitHub and then builds and deploys it on OpenShift.