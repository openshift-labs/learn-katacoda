For this tutorial, you're going to create a simple application that involves a [frontend](https://github.com/openshift/pipeliness-vote-ui) and [backend](https://github.com/openshift/pipelines-vote-api). This application needs to deploy in a new project (i.e. Kubernetes namespace). You can start by creating the project with:

`oc new-project pipelines-tutorial`{{execute}}

You can also deploy the same applications by applying the artifacts available in k8s directory of the respective repo.

## Deploying through Web Console

If you deploy the application directly, you should be able to see the deployment in the OpenShift Web Console by switching over to the **Developer** perspective of the OpenShift Web Console. Change from **Administrator** to **Developer** from the drop-down as shown below:

![Web Console Developer](../../assets/middleware/pipelines/web-console-developer.png)

Make sure you are on the `pipelines-tutorial` project by selecting it from the **Project** dropdown menu. Either search for `pipelines-tutorial` in the search bar or scroll down until you find `pipelines-tutorial` and click on the name of your project.

![Web Console Login](../../assets/middleware/pipelines/web-console-project.png)

Next, we'll work on creating a sample `Task` that outputs to the console!
