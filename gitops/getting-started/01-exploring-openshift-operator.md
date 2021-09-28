Welcome! In this section we will be exploring the OpenShift GitOps
Operator, what it installs, and how all the components fit together.

## Logging in to the Cluster via Dashboard

Click the [OpenShift Web Console](https://console-openshift-console-[[HOST_SUBDOMAIN]]-443-[[KATACODA_HOST]].environments.katacoda.com) tab to open the OpenShift Web UI. 

You will then be able to login with admin permissions with:

* **Username:** ``admin``{{copy}}
* **Password:** ``admin``{{copy}}

## Exploring the GitOps Operator Installation

The OpenShift GitOps Operator was installed via the Operator Hub. You
can view this installation via the UI in the Administrator Perspective:

* Click on `Operators` drop down on the leftside navigation.
* Click on `Installed Operators`
* In the `Project` dropdown, make sure `openshift-gitops` is selected.

You should see that the OpenShift GitOps Operator is installed.

![OpenShift GitOps Installed](../../assets/gitops/os-gitops-installed.png)

Another way to view what was installed is to run the following:

`oc get operators`{{execute}}

This should have the following output.

```shell
NAME                                                  AGE
openshift-gitops-operator.openshift-operators         25m
```

This Operator is a "meta" Operator that installs both Argo CD and the
Tekton Operator. This is why you see both the GitOps Operator and the
Tekton Operator listed.

Finally, you can verify the installation by running `oc get pods -n openshift-gitops`{{execute}}

You should something similar to the following output.

```shell
NAME                                                          READY   STATUS    RESTARTS   AGE
cluster-b5798d6f9-p9mt5                                       1/1     Running   0          12m
kam-69866d7c48-hr92f                                          1/1     Running   0          12m
openshift-gitops-application-controller-0                     1/1     Running   0          12m
openshift-gitops-applicationset-controller-6447b8dfdd-2xqw2   1/1     Running   0          12m
openshift-gitops-redis-74bd8d7d96-72fmd                       1/1     Running   0          12m
openshift-gitops-repo-server-c999f75d5-7jfc8                  1/1     Running   0          12m
openshift-gitops-server-6ff4fbc8f6-fpfdp                      1/1     Running   0          7m47s
```

Once you see the all the pods running, you can proceed!
