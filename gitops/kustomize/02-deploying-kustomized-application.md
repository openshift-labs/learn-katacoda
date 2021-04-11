In previous scenarios, you learned that in a GitOps workflow; the
entire application stack (including infrastructure) is reflected
in a git repo. The challenge is how to do this without duplicating
YAML.

So now that you've explored `kustomize`, let's see how it fits into Argo
CD and how it can be used in a GitOps workflow.

## The Argo CD Web Console

To get to the Argo CD Web UI; click the [Argo CD Web Console](https://argocd-cluster-server-openshift-gitops.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com) tab.

Once you have accepted the self signed certificate, you should be
presented with the Argo CD login screen.

![ArgoCD Login](../../assets/gitops/argocd-login.png)

You can login with the following
* **Username:** ``admin``{{copy}}
* **Password:** `oc extract secret/argocd-cluster-cluster -n openshift-gitops --to=-`{{execute}

