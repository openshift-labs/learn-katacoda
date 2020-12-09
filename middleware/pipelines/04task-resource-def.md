Tasks can also take parameters. This way, you can pass various flags to be used in this Task. These `params` can be instrumental in making your Tasks more generic and reusable across Pipelines. For example, a `Task` could apply a custom Kubernetes manifest, like the example below. This will be needed for deploying an image on OpenShift in our next section. In addition, we'll cover the `workspaces` during our `Pipeline` step.

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

Create the `apply-manifests` task:

`oc create -f tasks/apply_manifest_task.yaml`{{execute}}

We'll also create a `update-deployment` task, which can be seen with a `cat` command:

`oc create -f tasks/update_deployment_task.yaml`{{execute}}

Finally, we can create a PersistentVolumeClaim to provide the filesystem for our pipeline execution, explained more in the next step:

`oc create -f resources/persistent_volume_claim.yaml`{{execute}}

You can take a look at the tasks you created using the [Tekton CLI](https://github.com/tektoncd/cli/releases):

`tkn task ls`{{execute}}

You should see similar output to this:

```
NAME                DESCRIPTION   AGE
apply-manifests                   4 seconds ago
hello                             1 minute ago
update-deployment                 3 seconds ago
```

In the next section, you will create a pipeline that takes the source code of an application from GitHub and then builds and deploys it on OpenShift.