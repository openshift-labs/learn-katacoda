Once the Operator is installed, we need to make some customizations
specific for this lab environment. We've set these up in a script
for you.

`bash ~/scripts/argocd-postinstall.sh`{{execute}}

> **NOTE** Feel free to take a look! It's well commented!

Once it's done, you can now access the Argo CD UI. The information
needed to login to the UI can be extracted from the cluster.

The Operator installs the password in a secret. Extract this password to use to login to the ArgoCD instance.

`oc extract secret/argocd-cluster-cluster -n openshift-gitops --to=-`{{execute}}

To get the route for the ArgoCD UI:

`oc get route argocd-cluster-server -n openshift-gitops -o jsonpath='{.spec.host}{"\n"}'`{{execute}}

Open up a new Tab and visit the URL. Once you visit the URL in your browser, you should be presented with something that looks like this.


![ArgoCD Login](../../assets/gitops/argocd-login.png)


Go ahead and login as `admin` with the password you've extracted above.

You should see this screen:

![ArgoCD](../../assets/gitops/argocd.png)
