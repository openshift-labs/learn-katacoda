`Tasks` consist of some steps that get executed sequentially. Each step gets executed in a separate container within the same task pod. They can have inputs and outputs to interact with other `Tasks` as part of a pipeline.

For this exercise, you should create the _s2i-nodejs_ and _openshift-client_ tasks from the catalogue repositories using oc. These are the tasks you add to your pipeline for this workshop.

Create the _s2i-nodejs_ task that defines and build a container image for the _nodejs-ex_ application and push the resulting image to an image registry:

`oc create -f tektontasks/s2i-nodejs-task.yaml`{{execute}}

Create the _openshift-client_ task that will deploy the image created by _s2i-nodejs_ as a container on OpenShift:

`oc create -f tektontasks/openshift-client-task.yaml`{{execute}}

**Note**: For convenience, the tasks have been copied from their original locations in the Tekton and OpenShift catalogue git repositories to the workshop.

You can take a look at the list of tasks using the Tekton CLI (tkn):

`tkn task ls`{{execute}}

You should see similar output to this:

`
NAME                  AGE
openshift-client  58 seconds ago
s2i-nodejs           1 minute ago
`

In the next section, you will examine the task definitions you just created to gain a better understanding of the pipeline you will create.