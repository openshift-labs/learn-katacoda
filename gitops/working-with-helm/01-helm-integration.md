Welcome! In this section we will be exploring the native Helm integration
within Argo CD.

## Background

## Exploring Manifests

## Deploying The Application

Before we deploy this application, make sure you've opened the Argo CD
Web Console.

To get to the Argo CD Web UI; click the [Argo CD Web Console](https://openshift-gitops-server-openshift-gitops.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com) tab.

Once you have accepted the self signed certificate, you should be
presented with the Argo CD login screen.

![ArgoCD Login](../../assets/gitops/argocd-login.png)

You can login with the following
* **Username:** ``admin``{{copy}}
* **Password:** `oc extract secret/openshift-gitops-cluster -n openshift-gitops --to=-`{{execute}}

Apply the Argo CD `Application` manifest to get this Helm chart deployed.

`oc apply -f ~/resources/apps/quarkus-app.yaml`{{execute}}

This should create the `quarkus-app` application. Note the Helm icon
⎈ denoting it's a Helm application.

![quarkus-app](../../assets/gitops/quarkus-app.png)

Clicking on this "card" will take you to the application overview
page. Clicking on "show hidden resources" should expand the "tree"
view.

![quarkus-app-tree](../../assets/gitops/quarkus-app-tree.png)

Grab the URL by running the following command: `oc get route/quarkus-app -n demo  -o jsonpath='{.spec.host}{"\n"}'`{{execute}}

If you visit that URL, you should see the following page.

![gitops-loves-helm](../../assets/gitops/gitops-loves-helm.png)


This is a valid, and completely supported way of deploying your Helm
charts using Argo CD. But this isn't GitOps friendly. Lets see how we
can use Helm in a GitOps workflow.

Keep the Argo CD WebUI tab open for the next exercise, where we'll
explore a more GitOps friendly way of deploying Helm charts.