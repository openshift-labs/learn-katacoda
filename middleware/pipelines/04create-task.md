`Tasks` consist of some steps that get executed sequentially. Each step gets executed in a separate container within the same task pod. They can have inputs and outputs to interact with other `Tasks` as part of a pipeline.

For this exercise, you will create the _s2i-nodejs_ task from the catalogue repositories using oc. This is the first of two tasks you add to your pipeline for this workshop.

The _s2i-nodejs_ task has been broken into pieces below to help highlight its key aspects.

_s2i-nodejs_ starts by defining a property called inputs, as shown below. Underneath inputs, a property called resources specify that a resource of type _git_ is required. This property indicates that this task takes a git repository as an input.

```
spec:
  inputs:
    resources:
      - name: source
        type: git
```

The params property below defines fields that must be specified when using the task (e.g. the version of Node.js to use).

```
    params:
      - name: VERSION
        description: The version of the nodejs
        default: '12'
      - name: PATH_CONTEXT
        description: The location of the path to run s2i from.
        default: .
      - name: TLSVERIFY
        description: Verify the TLS on the registry endpoint (for push/pull to a non-TLS registry)
        default: "true"
```

There is also an _outputs_ property shown below that is used to specify that something is output as a result of running this task. The type of output is _image_. This property specifies that this task creates an image from the git repository provided as an input.

Many resource types are possible and not only limited to git and image. You can find out more about the possible resource types in the [Tekton documentation](https://github.com/tektoncd/pipeline/blob/master/docs/resources.md#resource-types).

```
  outputs:
    resources:
      - name: image
        type: image
```

For each step of the task, a steps property is used to define what steps will run during this task. Each step is denoted by its name. _s2i-nodejs_ has three steps:

generate
```
    - name: generate
      image: quay.io/openshift-pipeline/s2i
      workingdir: /workspace/source
      command: ['s2i', 'build', '$(inputs.params.PATH_CONTEXT)', 'centos/nodejs-$(inputs.params.VERSION)-centos7', '--as-dockerfile', '/gen-source/Dockerfile.gen']
      volumeMounts:
        - name: gen-source
          mountPath: /gen-source
      resources:
        limits:
          cpu: 500m
          memory: 1Gi
        requests:
          cpu: 500m
          memory: 1Gi
```

build
```
    - name: build
      image: quay.io/buildah/stable
      workingdir: /gen-source
      command: ['buildah', 'bud', '--tls-verify=$(inputs.params.TLSVERIFY)', '--layers', '-f', '/gen-source/Dockerfile.gen', '-t', '$(outputs.resources.image.url)', '.']
      volumeMounts:
        - name: varlibcontainers
          mountPath: /var/lib/containers
        - name: gen-source
          mountPath: /gen-source
      resources:
        limits:
          cpu: 500m
          memory: 1Gi
        requests:
          cpu: 500m
          memory: 1Gi
      securityContext:
        privileged: true
```

push
```
    - name: push
      image: quay.io/buildah/stable
      command: ['buildah', 'push', '--tls-verify=$(inputs.params.TLSVERIFY)', '$(outputs.resources.image.url)', 'docker://$(outputs.resources.image.url)']
      volumeMounts:
        - name: varlibcontainers
          mountPath: /var/lib/containers
      resources:
        limits:
          cpu: 500m
          memory: 1Gi
        requests:
          cpu: 500m
          memory: 1Gi
      securityContext:
        privileged: true
```

Each step above runs serially in its own container. Since the generate step uses an s2i command to generate a Dockerfile from the source code from the git repository input, the image used for its container has s2i installed.

The build and push steps both use a Buildah image to run commands to build the Dockerfile created by the generate step and then push that image to an image registry (i.e. the output of the task).

You can see the images used for both these steps via the image property of each step.

The order of the steps above (i.e. 1. generate 2. build 3. push) is used to specify when these steps should run. For _s2i-nodejs_, this means _generate_ will run followed by build and then the push step will execute last.

Under the resources property of each step, you can define the amount of resources needed for the container in terms of CPU and memory.

```
resources:
limits:
    cpu: 500m
    memory: 1Gi
requests:
    cpu: 500m
    memory: 1Gi
```

You can view the full definition of this task in the [OpenShift Pipelines Catalog GitHub repository](https://github.com/openshift/pipelines-catalog/blob/master/s2i-nodejs/s2i-nodejs-task.yaml) or by using `cat ./tektontasks/s2i-nodejs-task.yaml`.

Create the _s2i-nodejs_ task that defines and builds a container image for the _nodejs-ex_ application and push the resulting image to an image registry:

`oc create -f tektontasks/s2i-nodejs-task.yaml`{{execute}}

In the next section, you will examine the second task definitions that will be needed for our pipeline.