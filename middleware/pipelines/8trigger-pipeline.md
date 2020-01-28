Now that you have created tasks, a pipeline, and pipeline resources, you are ready to trigger a pipeline that will deploy the _nodejs-ex_ application out to OpenShift.

As mentioned earlier, a PipelineRun is the custom resource used to trigger a pipeline. In this exercise, you will create a PipelineRun via tkn to deploy the nodejs-ex application out to OpenShift.

The PipelineRun definition below is how you can trigger a pipeline and tie it to the git and image resources that are used for this specific invocation:

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

Under the spec property, you’ll see the pipelineRef property where the pipeline to be used is specified. You should see the name of the pipeline you created (i.e. deploy-pipeline).

The last property of the PipelineRun of note is resources. This is how the specific git repository and image registry urls can be entered for the PipelineRun. You’ll see the pipeline resource references you just created in the PipelineRun definition.

While learning about the resource definition behind a pipeline run is important, you do not have to define this resource yourself to trigger a pipeline run. You can create the above PipelineRun to deploy the nodejs-ex application out to OpenShift via tkn.

The tkn command below triggers a pipeline run. The -r flag allows you specify what pipeline resources will be included in a pipeline run. You can see the git and image pipeline resources you created earlier.

You will also notice the -s flag for specifying a service account. This is how you can add your pipeline service account to the pipeline run.

Run the command below to kick off the pipeline run:

```tkn pipeline start deploy-pipeline \
-r app-git=nodejs-ex-git \
-r app-image=nodejs-ex-image \
-s pipeline```{{execute}}

After running the command above, the pipeline you created earlier is now running and a number of pods are created to execute the tasks that are defined as part of the pipeline. After 4-5 minutes, the pipeline run should finish successfully.

Additionally, you will begin to see the pipeline run logs immediately after the pod for the first task is done initializing.

Before continuing, grab the name of the pipeline run and save it to an environment variable so you can learn more about the pipeline run later in this workshop:

```RUN=`tkn pr ls -o jsonpath='{$.items[?(@.status.conditions[0].reason=="Running")].metadata.name}' | tr ' ' '\n' | head -1`; echo $RUN```{{execute}}

To view the pipeline run created, run the following tkn command:

`tkn pr ls`{{execute}}

You should see the NAME of your pipeline run, the pipeline run start time (i.e. STARTED), and the STATUS as Running.

As mentioned earlier, when a task is running as part of a pipeline, it allocates a pod that will host steps that each run in a separate container. You can see the pod for the first task on your pipeline (i.e. build) by running the following command:

`oc get pods`{{execute}}

You should see a pod with a name consisting of deploy-pipeline-run and build. When build finishes, another pod will be allocated to host the step of the deploy task of your pipeline.

## Tekton CLI Logs

The logs output tells you what tasks are running as well as what step it is running. You’ll see the output structured as [task_name : step_name]. An example from this pipeline run is below for the generate step of the build task:

[build : generate]

As these logs come in via tkn, you can see output from the task-step combinations from the build task:

[build : generate]
[build : build]
[build : push]

You can also eventually see the output of the deploy task execution with its one step:

[deploy : oc]

Upon the successful completion of the pipeline run, you will see the following output from the logs:

[deploy : oc] deploymentconfig.apps.openshift.io/nodejs-ex rolled out

While the pipeline run is executing, you can take a look at how you can visualize a pipeline run through the OpenShift web console in the next section. Leave the logs running so that you can confirm the successful deployment message when the pipeline run finishes.
