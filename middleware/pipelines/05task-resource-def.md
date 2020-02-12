The openshift-client task you will create is simpler as shown below:

```
apiVersion: tekton.dev/v1alpha1
kind: Task
metadata:
  name: openshift-client
spec:
  inputs:
    params:
      - name: ARGS
        description: The OpenShift CLI arguments to run
        default: help
  steps:
    - name: oc
      image: quay.io/openshiftlabs/openshift-cli-tekton-workshop:2.0
      command: ["/usr/local/bin/oc"]
      args:
        - "$(inputs.params.ARGS)"
```

_openshift-client_ doesn't have any inputs or outputs associated with it. It also only has one step named oc.

This step uses an image with oc installed and runs the oc root command along with any args passed to the step under the args property. This task allows you to run any command with oc. You will use it to deploy the image created by the _s2i-nodejs_ task to OpenShift. You will see how this takes place in the next section.

Create the _openshift-client_ task that will deploy the image created by _s2i-nodejs_ as a container on OpenShift:

`oc create -f tektontasks/openshift-client-task.yaml`{{execute}}

**Note**: For convenience, the tasks have been copied from their original locations in the Tekton and OpenShift catalogue git repositories to the workshop.

You can take a look at the list of tasks using the Tekton CLI (tkn):

`tkn task ls`{{execute}}

You should see similar output to this:

```
NAME                  AGE
openshift-client     58 seconds ago
s2i-nodejs           3 minutes ago
```

In the next section, you will create a pipeline that uses _s2i-nodejs_ and _openshift-client_ tasks. 