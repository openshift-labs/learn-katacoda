Now that the pipeline is created, you can trigger it to execute the tasks specified in the pipeline. This is done by creating a `PipelineRun` via `tkn`.

A `PipelineRun` is how you can start a pipeline and tie it to the persistentVolumeClaim and params that should be used for this specific invocation.

Lets start a pipeline to build and deploy backend application using `tkn`:

`tkn pipeline start build-and-deploy \
    -w name=shared-workspace,volumeClaimTemplateFile=resources/persistent_volume_claim.yaml \
    -p deployment-name=vote-api \
    -p git-url=http://github.com/openshift-pipelines/vote-api.git \
    -p IMAGE=image-registry.openshift-image-registry.svc:5000/pipelines-tutorial/vote-api \`{{execute}}

Similarly, start a pipeline to build and deploy frontend application:

`tkn pipeline start build-and-deploy \
    -w name=shared-workspace,volumeClaimTemplateFile=resources/persistent_volume_claim.yaml \
    -p deployment-name=vote-ui \
    -p git-url=http://github.com/openshift-pipelines/vote-ui.git \
    -p IMAGE=image-registry.openshift-image-registry.svc:5000/pipelines-tutorial/vote-ui \`{{execute}}

As soon as you start the `build-and-deploy` pipeline, a pipelinerun will be instantiated and pods will be created to execute the tasks that are defined in the pipeline.

`tkn pipeline list`{{execute}}

Above we have started `build-and-deploy` pipeline, with relevant pipeline resources to deploy backend/frontend application using a single pipeline

`tkn pipelinerun ls`{{execute}}

Check out the logs of the pipelinerun as it runs using the `tkn pipeline logs` command which interactively allows you to pick the pipelinerun of your interest and inspect the logs:

`tkn pipeline logs -f`{{execute}}

After a few minutes, the pipeline should finish successfully!

`tkn pipelinerun list`{{execute}}