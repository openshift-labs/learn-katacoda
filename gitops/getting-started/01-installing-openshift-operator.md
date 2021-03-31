The easiest way to install the OpenShift GitOps Operator is via the
OpenShift UI.


## Logging in to the Cluster via Dashboard

Click the [Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com) tab to open the dashboard. 

You will then able able to login with admin permissions with:

* **Username:** ``admin``{{copy}}
* **Password:** ``admin``{{copy}}

## Installing GitOps Operator

You can install the Operator via the UI in the Administrator Perspective:

* Click on `Operators` drop down on the leftside navigation.
* Click on `OperatorHub`
* In the search box type `openshift gitops`.
* Select the `Red Hat OpenShift GitOps` card.
* Click `Install` on the `Red Hat OpenShift GitOps` installation dialog.
* Accept all the defaults in the `Install Operator` page and click `Install`

Another way to do this is to use the manifest directly. You can use the
resources in this repo to install the OpenShift GitOps Operator:

`oc apply -k manifests/operator-install`{{execute}}


This uses [kustomize](https://kustomize.io/) to load the manifests needed to install the OpenShift GitOps Operator. 

There is only 1 that is needed: `manifests/operator-install/openshift-gitops-operator-sub.yaml`{{open}}

> :bulb: **NOTE**: You don't have to use `kustomize`. You can `oc apply -f` the file individually.

The Operator is a "meta" Operator that installs both the ArgoCD Operator
and Instance; and the Tekton Operator and Instance.

Verify the installation by running `oc get pods -n openshift-gitops`. You should see the following output

```shell
$ oc get pods -n openshift-gitops
NAME                                                    READY   STATUS    RESTARTS   AGE
argocd-cluster-application-controller-6f548f74b-48bvf   1/1     Running   0          54s
argocd-cluster-redis-6cf68d494d-9qqq4                   1/1     Running   0          54s
argocd-cluster-repo-server-85b9d68f9b-4hj52             1/1     Running   0          54s
argocd-cluster-server-78467b647-8lcv9                   1/1     Running   0          54s
cluster-86f8d97979-lfdhv                                1/1     Running   0          56s
kam-7ff6f58c-2jxkm                                      1/1     Running   0          55s
```

> :heavy_exclamation_mark: **NOTE**: It'll take some time so you may want to run `watch oc get pods -n openshift-gitops`
