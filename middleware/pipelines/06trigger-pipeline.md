Now that the pipeline is created, you can trigger it to execute the tasks specified in the pipeline. This is done by creating a `PipelineRun` via `tkn`.

# Trigger a Pipeline via CLI

Let's start a pipeline to build and deploy our backend application using `tkn`. By creating a `PipelineRun` with the name of our applied `Pipeline`, we can define various arguments to our command like `params` that will be used in the `Pipeline`.  For example, we can apply a request for storage with a `persistentVolumeClaim`, as well as define a name for our `deployment`, `git-url` repository to be cloned, and `IMAGE` to be created.

We'll first build and deploy our backend application using the following command, with the params already included for our specific demo:

`tkn pipeline start build-and-deploy -w name=shared-workspace,claimName=source-pvc -p deployment-name=pipelines-vote-api -p git-url=https://github.com/openshift/pipelines-vote-api.git -p IMAGE=image-registry.openshift-image-registry.svc:5000/pipelines-tutorial/vote-api --showlog`{{execute}}

Similarly, start a pipeline to build and deploy the frontend application:

`tkn pipeline start build-and-deploy -w name=shared-workspace,claimName=source-pvc -p deployment-name=pipelines-vote-ui -p git-url=https://github.com/openshift/pipelines-vote-ui.git -p IMAGE=image-registry.openshift-image-registry.svc:5000/pipelines-tutorial/vote-ui --showlog`{{execute}}

As soon as you start the `build-and-deploy` pipeline, a `PipelineRun` will be instantiated and pods will be created to execute the tasks that are defined in the pipeline. To display a list of Pipelines, use the following command:

`tkn pipeline ls`{{execute}}

Again, notice the reusability of pipelines, and how one generic `Pipeline` can be triggered with various `params`. We've started the `build-and-deploy` pipeline, with relevant pipeline resources to deploy backend/frontend application using a single pipeline. Let's list our PipelineRuns:

`tkn pipelinerun ls`{{execute}}

After a few minutes, the pipeline should finish successfully!

`tkn pipelinerun ls`{{execute}}

## Access Pipeline via Web Console

To view the `PipelineRun` visually, visit the Pipelines section of the developer perspective. From here, you can see the details of our `Pipeline`, including the YAML file we've applied, the `PipelineRun`, input custom `params`, and more:

![Web Console Pipelines](../../assets/middleware/pipelines/web-console-developer.png)

Congrats! Your `Pipeline` has successfully ran, and the final step will provide instructions on how to access the deployed image.
