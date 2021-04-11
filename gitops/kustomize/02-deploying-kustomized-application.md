In previous scenarios, you learned that in a GitOps workflow; the
entire application stack (including infrastructure) is reflected
in a git repo. The challenge is how to do this without duplicating
YAML.

So now that you've explored `kustomize`, let's see how it fits into Argo
CD and how it can be used in a GitOps workflow.

Before preceeding, move back into the home directory: `cd ~`{{execute}}

## The Argo CD Web Console

To get to the Argo CD Web UI; click the [Argo CD Web Console](https://argocd-cluster-server-openshift-gitops.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com) tab.

Once you have accepted the self signed certificate, you should be
presented with the Argo CD login screen.

![ArgoCD Login](../../assets/gitops/argocd-login.png)

You can login with the following
* **Username:** ``admin``{{copy}}
* **Password:** `oc extract secret/argocd-cluster-cluster -n openshift-gitops --to=-`{{execute}}

## Base Application

In a previous scenario, we deployed a sample appication that had a
picture of a blue square. To deploy the application, run the following
command:

`oc apply -f resources/bgd-app/bgd-app.yaml`{{execute}}

This should create an `Application` in the Argo CD UI.

![bgdk-app](../../assets/gitops/bgdk-app.png)

You can wait for the rollout of the application by running `oc rollout status deploy/bgd -n bgd`{{execute}}

Once it's done rolling out, you can open the application's URL by [CLICKING HERE](http://bgd-bgd.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com)

It should look something like this.

![bgd](../../assets/gitops/bgd.png)

If you did the previous scenario, this should be familiar. But what
if I wanted to deploy this application with modifications?

## Kustomized Application

Argo CD has native support for Kustomize. You can use this to avoid
duplicating YAML for each deployment. This is especially good to
use if you have different environements or clusters you're deploying
to.

Take a look at the `Application` definition:  `bgdk-app/bgdk-app.yaml`{{open}}

This application is pointed to the [same repo](https://github.com/redhat-developer-demos/openshift-gitops-examples) but [different directory](https://github.com/redhat-developer-demos/openshift-gitops-examples/tree/main/apps/bgd/overlays/bgdk).

This is using a concept of an "overlay", where you have a "base"
set of manifests and you overlay your customizations. Take a look
at the `examples/bgdk-overlay/kustomization.yaml`{{open}} example
file.

This `kustomization.yaml` take the base application and patches the
manifest so that we get a yellow square instead of a blue one. It
also deploys the application to the `bgdk` namespace (denoted by
the `namespace:` section of the file).

Deploy this application:  `kubectl apply -f bgdk-app/bgdk-app.yaml`{{execute}}

This should show you two apps on the Argo CD UI.