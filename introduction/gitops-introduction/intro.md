There are multiple approaches to how to deploy your applications into OpenShift, in this scenario we are going to explore GitOps.

In case you haven't read it yet, we encorage you to read our blog post [Introduction to GitOps with OpenShift](https://blog.openshift.com/introduction-to-gitops-with-openshift/) where you will learn
the GitOps basic principles and patterns on OpenShift.

This course will guide you through the deployment of a simple application using GitOps Principles and Patterns on OpenShift.

We will use [ArgoCD](https://argoproj.github.io/argo-cd/) as our GitOps tool to deploy a simple application into our cluster, first we will deploy our application from the command line using the Argo CD CLI, after that we will re-deploy our application through the WebUI.
