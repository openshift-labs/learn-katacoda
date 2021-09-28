In this environment, we have some
example manifesets taken from our [sample GitOps repo](https://github.com/redhat-developer-demos/openshift-gitops-examples).
We'll be uisng this repo to test. These manifests include:

* A **Namespace**: `openshift-gitops-examples/apps/bgd/overlays/bgd/bgd-ns.yaml`{{open}}
* A **Deployment**: `openshift-gitops-examples/apps/bgd/overlays/bgd/bgd-deployment.yaml`{{open}}
* A **Service**: `openshift-gitops-examples/apps/bgd/overlays/bgd/bgd-svc.yaml`{{open}}
* A **Route**: `openshift-gitops-examples/apps/bgd/overlays/bgd/bgd-route.yaml`{{open}}

Collectively, this is known as an `Application` within ArgoCD. Therefore,
you must define it as such in order to apply these manifest in your
cluster.

Open up the Argo CD `Application` manifest: `openshift-gitops-examples/components/applications/bgd-app.yaml`{{open}}

Let's break this down a bit.

* ArgoCD's concept of a `Project` is different than OpenShift's. Here you're installing the application in ArgoCD's `default` project (`.spec.project`). **NOT** OpenShift's `default` project.
* The destination server is the server we installed ArgoCD on (noted as `.spec.destination.server`).
* The manifest repo where the YAML resides and the path to look for the YAML is under `.spec.source`.
* The `.spec.syncPolicy` is set to `false`. Note that you can have Argo CD automatically sync the repo.
* The last section `.spec.sync` just says what are you comparing the repo to. (Basically "Compare the running config to the desired config")

The `Application` CR (`CustomResource`) can be applied by running the following:

`oc apply -f ~/resources/openshift-gitops-examples/components/applications/bgd-app.yaml`{{execute}}

This should create the `bgd-app` in the ArgoCD UI.

![bgdk-app](../../assets/gitops/bgd-app.png)

Clicking on this "card" takes you to the overview page. You may see it as still progressing or full synced. 

![synced-app](../../assets/gitops/synced-app.png)

> **NOTE**: You may have to click on `show hidden resources` on this page to see it all

At this point the application should be up and running. You can see
all the resources created with the `oc get pods,svc,route -n bgd`{{execute}}
command. The output should look like this:

```shell
NAME                       READY   STATUS    RESTARTS   AGE
pod/bgd-788cb756f7-kz448   1/1     Running   0          10m

NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/bgd   ClusterIP   172.30.111.118   <none>        8080/TCP   10m

NAME                           HOST/PORT                                PATH   SERVICES   PORT   TERMINATION   WILDCARD
route.route.openshift.io/bgd   bgd-bgd.apps.example.com          bgd        8080                 None
```

First wait for the rollout to complete `oc rollout status deploy/bgd -n bgd`{{execute}} 

Then visit your application using the route by clicking [HERE](http://bgd-bgd.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com)

Your application should look like this.

![bgd](../../assets/gitops/bgd.png)

Let's introduce a change! Patch the live manifest to change the color
of the box from blue to green:

`oc -n bgd patch deploy/bgd --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/env/0/value", "value":"green"}]'`{{execute}}

Wait for the rollout to happen:

`oc rollout status deploy/bgd -n bgd`{{execute}}

If you refresh your tab where your application is running you should see a green square now.

![bgd-green](../../assets/gitops/bgd-green.png)

Looking over at your Argo CD Web UI, you can see that Argo detects your
application as "Out of Sync".

![outofsync](../../assets/gitops/out-of-sync.png)

You can sync your app via the Argo CD by:

* First clicking `SYNC`
* Then clicking `SYNCHRONIZE`

Conversely, you can run `argocd app sync bgd-app`{{execute}}

After the sync process is done, the Argo CD UI should mark the application as in sync.

![fullysynced](../../assets/gitops/fullysynced.png)

If you reload the page on the tab where the application is running. It
should have returned to a blue square.

![bgd](../../assets/gitops/bgd.png)

You can setup Argo CD to automatically correct drift by setting the
`Application` manifest to do so. Here is an example snippet:

```yaml
spec:
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

Or, as in our case, after the fact by running the following command:

`oc patch application/bgd-app -n openshift-gitops --type=merge -p='{"spec":{"syncPolicy":{"automated":{"prune":true,"selfHeal":true}}}}'`{{execute}}