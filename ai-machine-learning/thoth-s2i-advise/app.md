Before we explore more about the build process, let's check the sample repo we have for the demo,
and explore more about the s2i process. 

Here is the example repo we are going to try today - 

[https://github.com/thoth-station/s2i-example](https://github.com/thoth-station/s2i-example)

Now let's check out the `log-thoth` branch.
The upstream link to the same is - [https://github.com/thoth-station/s2i-example/tree/log-thoth](https://github.com/thoth-station/s2i-example/tree/log-thoth)

If you go to app.py, it's a simple Python app that prints `Hello thoth` every 10 seconds. 
And you have a Pipfile that has `daiquiri` as the only package. That is the standard python project, we are going to experiment with. 

Now let's explore the `openshift.yaml`. 
End of the yaml, we declare the image to be `s2i-thoth-ubi8-py38`
```
  - apiVersion: "image.openshift.io/v1"
    kind: ImageStream
    metadata:
      labels:
        app: "s2i-example-log"
      name: "s2i-thoth-ubi8-py38"
    spec:
      tags:
        - name: "latest"
          from:
            kind: "DockerImage"
            name: "quay.io/thoth-station/s2i-thoth-ubi8-py38"
          referencePolicy:
            type: "Source"
```
And we use this under BuildConfig under line 26, stating our source repo to be - 
```
git:
    uri: "https://github.com/thoth-station/s2i-example"
    ref: "log-thoth"
```
You could change this to point to your repo fork.
Now that we have successfully explored the repo, and are using a Thoth powered s2i image, let's explore some configuration options, that 
thoth image provides out of box. 