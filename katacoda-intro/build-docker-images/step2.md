With the project created, it is now possible to add applications which make up the project. These applications can come from multiple different sources. If the source specifies a Docker Image, it is pulled from the registry and deployed. If the application source is a Git repository then OpenShift clones and builds the Dockerfile in the root directory.

## Task

The first component required by the project is an HTTP Server. The server is based on Node.js and stored in a publically accessible Github folder. If the repository required authentication, then that can be specified using additional parameters.

The command below creates the app with a friendly name of _frontend_. The name can be used in future commands.

`oc new-app https://github.com/katacoda/nodejs-http-server --name=frontend`{{execute}}

As a Git repository was specified, OpenShift starts a build.

The build status and history can be viewed with the command `oc get builds`{{execute}}

It can take a few moments for the build to be registered and started.

More detailed insight into the build history can be seen using `oc describe build frontend`{{execute}}

To gain accessed to the latest build logs, use `oc logs bc/frontend -f`{{execute}}

Once the build has completed, the resulting image is uploaded to the internal Docker Registry, explained in the next step.
