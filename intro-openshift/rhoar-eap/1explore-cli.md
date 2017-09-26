The OpenShift CLI is accessed using the command _oc_. From here, you can administrate the entire OpenShift cluster and deploy new applications.

The CLI exposes the underlying Kubernetes orchestration system with the enhancements made by OpenShift. Users familiar with Kubernetes will be able to adopt to OpenShift quickly. The CLI is ideal in situations where you are:

1) Working directly with project source code.

2) Scripting OpenShift operations.

3) Restricted by bandwidth resources and cannot use the web console.

For this section, our task is going to be creating our first project.

## What is a project? Why does it matter?
The goal of this scenario is to get a project created and running, which you'll be doing with the **web console** in the next section.

OpenShift is often referred to as a container application platform in that it is a platform designed for the development and deployment of containers.

To contain your application, we use projects. The reason for having a project to contain your application is to allow for controlled access and quotas for developers or teams.

More technically, it's a visualization of the Kubernetes namespace based on the developer access controls.

## Command Line Interface (CLI)
In this course, we're not focusing on CLI, but we want you to be aware of it in case using the command line is your thing. Check out our other courses which go into the use of the CLI in more depth. Now, we're just going to practice logging in so you can get some experience with how the CLI works.

## Task
Let's get started by logging in. Your task is to enter the following into the console:

`oc login`{{execute}}

When prompted, enter the following username and password:

**Username:** ``developer``{{execute}}

**Password:** ``developer``{{execute}}

Next, you can check if it was successful:

`oc whoami`{{execute}}

Should return a response of:

``developer``

That's it!

In the next step, we'll get started with creating your first project using the **web console**.
