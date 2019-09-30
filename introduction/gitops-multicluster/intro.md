In the [previous scenario](https://learn.openshift.com/introduction/gitops-introduction) we covered the basics around GitOps with OpenShift, in this scenario we are going to explore Multi-cluster GitOps with OpenShift.

In case you haven't read it yet, we encourage you to read our blog post [Multi-cluster Management with GitOps](https://blog.openshift.com) where you will learn
the basics around managing multi-cluster infrastructures using GitOps with OpenShift.

This course will guide you through the deployment of a simple application to multiple clusters, customize the application by cluster and perform a canary deployment, all of this using GitOps with OpenShift.

We will use [ArgoCD](https://argoproj.github.io/argo-cd/) as our GitOps tool to deploy a simple application into our clusters, first we will deploy our application from the command line using the Argo CD CLI, after that we will re-deploy our application through the WebUI.
