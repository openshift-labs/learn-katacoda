Once the Operator is installed, we need to make some customizations
specific for this lab environment. We've set these up in a script
for you.

`bash ~/resources/scripts/argocd-postinstall.sh`{{execute}}

> **NOTE** Feel free to take a look at the script! It's well commented!

Once it's done, you can now access the Argo CD UI. The password needed
is stored in a secret. Extract this password to use to login to the
ArgoCD instance.

`oc extract secret/argocd-cluster-cluster -n openshift-gitops --to=-`{{execute}}

To get to the Argo CD Web UI; Click [HERE](https://argocd-cluster-server-openshift-gitops.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com)

Once you visit the URL in your browser, and accept the self signed
certificate, you should be presented with something that looks like this.


![ArgoCD Login](../../assets/gitops/argocd-login.png)


Go ahead and login as `admin` with the password you've extracted above.

You should see this screen:

![ArgoCD](../../assets/gitops/argocd.png)

Keep this tab open for the next exercise.