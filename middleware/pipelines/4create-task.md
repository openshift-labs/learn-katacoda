Tasks consist of a number of steps that are executed sequentially. Each step is executed in a separate container within the same task pod. Tasks can have inputs and outputs in order to interact with other tasks as part of a pipeline.

For this exercise, you should create the s2i-nodejs and openshift-client tasks from the catalog repositories using oc. These will be the tasks you add to your pipeline for this workshop.

Create the s2i-nodejs task that will define and build a container image for the nodejs-ex application and push the resulting image to an image registry:

`oc create -f tektontasks/s2i-nodejs-task.yaml`{{execute}}

Create the openshift-client task that will deploy the image created by s2i-nodejs as a container on OpenShift:

`oc create -f tektontasks/openshift-client-task.yaml`{{execute}}

**Note**: For convenience, the tasks have been copied from their original locations in the Tekton and OpenShift catalog git repositories to the workshop.

You can take a look at the list of tasks using the Tekton CLI (tkn):

`tkn task ls`{{execute}}

You should see similar output to this:

`
NAME               AGE
openshift-client   58 seconds ago
s2i-nodejs         1 minute ago
`

In the next section, you will examine the task definitions you just created to gain a better understanding of the pipeline you will create.