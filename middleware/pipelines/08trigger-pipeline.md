Now that you have created tasks, a pipeline, and pipeline resources, you are ready to trigger a pipeline to deploy the _nodejs-ex_ application out to OpenShift. This is done by creating a `PipelineRun` via `tkn`.

The `PipelineRun` definition below is how you can trigger a pipeline and tie it to the git and image resources that are used for this specific invocation:

```
apiVersion: tekton.dev/v1alpha1
kind: PipelineRun
metadata:
  generateName: deploy-pipelinerun-
spec:
  pipelineRef:
    name: deploy-pipeline
    trigger:
      type: manual
      serviceAccount: 'pipeline'
    resources:
    - name: app-git
      resourceRef:
      name: nodejs-ex-git
    - name: app-image
      resourceRef:
      name: nodejs-ex-image
```

Under the spec property, you'll see the pipelineRef property where the pipeline to be used is specified. You should see the name of the pipeline you created (i.e. deploy-pipeline).

The last property of the PipelineRun of note is `resources`. This property is how the specific git repository and image registry URLs can be entered for the PipelineRun. You'll see the pipeline resource references you just created in the PipelineRun definition.

While learning about the resource definition behind a pipeline run is great, you do not have to define this resource yourself to trigger a pipeline run. You can create the above PipelineRun to deploy the _nodejs-ex_ application out to OpenShift via `tkn`.

The `tkn` command below triggers a pipeline run. The -r flag allows you to specify what pipeline resources are included in a pipeline run. You can see the git and image pipeline resources you created earlier.

You can also notice the -s flag for specifying a service account. This flag is how you can add your pipeline service account to the pipeline run.

Run the command below to kick off the pipeline run:

```tkn pipeline start deploy-pipeline \
-r app-git=nodejs-ex-git \
-r app-image=nodejs-ex-image \
-s pipeline```{{execute}}

After running this command, the pipeline you created earlier is now running. Some pods get created to execute the tasks defined as part of the pipeline. After 4-5 minutes, the pipeline run should finish successfully.

Additionally, you will begin to see the pipeline run logs immediately after the pod for the first task is done initializing.

## Tekton CLI Logs

The logs output tells you what tasks are running as well as what step it is running. You’ll see the output structured as [task_name : step_name]. An example from this pipeline run is below for the _generate_ step of the build task:

```
[build : generate]
```

As these logs come in via tkn, you can see the output from the task-step combinations from the build task:

```
[build : generate]
...
[build : build]
...
[build : push]
...
```

You can also eventually see the output of the deploy task execution with its one step:

```
[deploy : oc]
```

Upon the successful completion of the pipeline run, you will see the following output from the logs:

```
[deploy : oc] deploymentconfig.apps.openshift.io/nodejs-ex rolled out
```

While the pipeline run is executing, you can take a look at how you can visualize a pipeline run through the OpenShift web console in the next section. Leave the logs running so that you can confirm the successful deployment message when the pipeline run finishes.