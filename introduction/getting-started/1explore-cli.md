## Command Line Interface (CLI)

The OpenShift CLI is accessed using the command _oc_. From here, you can administrate the entire OpenShift cluster and deploy new applications.

The CLI exposes the underlying Kubernetes orchestration system with the enhancements made by OpenShift. Users familiar with Kubernetes will be able to adapt to OpenShift quickly. _oc_ provides all of the functionality of _kubectl_, along with additional functionality to make it easier to work with OpenShift. The CLI is ideal in situations where you are:

1) Working directly with project source code

2) Scripting OpenShift operations

3) Restricted by bandwidth resources and cannot use the web console

In this tutorial, we're not focusing on the OpenShift CLI, but we want you to be aware of it in case you prefer using the command line. You can check out our other courses that go into the use of the CLI in more depth. Now, we're just going to practice logging in so you can get some experience with how the CLI works.

## Exercise: Logging in with the CLI
Let's get started by logging in. Your task is to enter the following into the console:

`oc login -u developer`{{execute}}

When prompted, enter the following password:

**Password:** `developer`{{execute}}

Next, you can check if it was successful:

`oc whoami`{{execute}}

`oc whoami` should return a response of:

`developer`

That's it!

In the next step, we'll get started with creating your first project using the **web console**.
