A [`Task`](tasks.md) defines a series of `steps` that run in a desired order and complete a set amount of build work. Every `Task` runs as a Pod on your Kubernetes cluster with each `step` as its own container. For example, the following `Task` outputs "Hello World":

```
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: hello
spec:
  steps:
    - name: say-hello
      image: registry.access.redhat.com/ubi8/ubi
      command:
        - /bin/bash
      args: ['-c', 'echo Hello World']
```

Apply this Task to your cluster just like any other Kubernetes object. Then run it using `tkn`, the CLI tool for Tekton.

`oc apply -f tasks/hello.yaml`{{execute}}

`tkn task start --showlog hello`{{execute}}

The output will look similar to the following:

```
TaskRun started: hello-run-9cp8x
Waiting for logs to be available...
[say-hello] Hello World
```

In the next section, you will examine the task definitions that will be needed for our pipeline.