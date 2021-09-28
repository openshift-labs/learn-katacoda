Before we deploy the app, let's explore the build config and S2I image we will be using. 

Here is the example repo we are going to try today - 

[https://github.com/thoth-station/s2i-example-tensorflow](https://github.com/thoth-station/s2i-example-tensorflow)

Let's check out the `log-thoth-broken` branch.
The upstream link to the same is - [https://github.com/thoth-station/s2i-example/tree/log-thoth-broken](https://github.com/thoth-station/s2i-example/tree/log-thoth-broken)

If you go to app.py, it's a simple Python app that prints `Hello thoth` every 10 seconds. 
And you have a Pipfile that has `daiquiri` as the only package. That is the standard Python project, we are going to experiment with. 

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
    ref: "log-thoth-broken"
```
Now that we have successfully explored the repo, and are using a Thoth powered s2i image, let's explore some configuration options, that 
Thoth image provides out of box. 