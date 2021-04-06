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

`oc apply -k resources/operator-install`{{execute}}

This uses [kustomize](https://kustomize.io/) to load the manifest needed to install the OpenShift GitOps Operator.

In this case, there is only 1 file that is applied: `operator-install/openshift-gitops-operator-sub.yaml`{{open}}

Which is applied via the `kustomze` file: `operator-install/kustomization.yaml`{{open}}

> **NOTE** You'll learn more about using `kustomize` in other scenarios. 

The Operator is a "meta" Operator that installs both Argo CD and
the Tekton Operator.

The installation might take a while, so you can wait for the
deployment to be created.

`until oc wait --for=condition=available --timeout=60s deploy argocd-cluster-server -n openshift-gitops ; do sleep 5 ; done`{{execute}}

> **NOTE** Seeing errors here is normal.

Once the deploymnet is created, you can wait for the rollout
of the deployment.

`oc rollout status deploy argocd-cluster-server -n openshift-gitops`{{execute}}

Verify the installation by running `oc get pods -n openshift-gitops`{{execute}}

You should something similar to the following output.

```shell
NAME                                                    READY   STATUS    RESTARTS   AGE
argocd-cluster-application-controller-6f548f74b-48bvf   1/1     Running   0          54s
argocd-cluster-redis-6cf68d494d-9qqq4                   1/1     Running   0          54s
argocd-cluster-repo-server-85b9d68f9b-4hj52             1/1     Running   0          54s
argocd-cluster-server-78467b647-8lcv9                   1/1     Running   0          54s
cluster-86f8d97979-lfdhv                                1/1     Running   0          56s
kam-7ff6f58c-2jxkm                                      1/1     Running   0          55s
```

Once you see the all the pods running, you can proceed!