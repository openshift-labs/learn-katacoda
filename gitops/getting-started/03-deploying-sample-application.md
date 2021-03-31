# Deploying A Sample Application

In [this repo](resources/manifests/bgdk-yaml), we have some manifesets
that you can use to test. This is a simple app that includes:

* A **Namespace**: `manifests/bgd-yaml/bgd-namespace.yaml`{{open}}
* A **Deployment**: `manifests/bgd-yaml/bgd-deployment.yaml`{{open}}
* A **Service**: `manifests/bgd-yaml/bgd-svc.yaml`{{open}}
* A **Route**: `manifests/bgd-yaml/bgd-route.yaml`{{open}}

Collectively, this is known as an `Application` within ArgoCD. Therefore,
you must define it as such in order to apply these manifest in your
cluster.

Here is the `Application` manifest we are going to use:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: bgdk-app
  namespace: openshift-gitops
spec:
  destination:
    namespace: openshift-gitops
    server: https://kubernetes.default.svc
  project: default
  source:
    path: resources/manifests/bgdk-yaml
    repoURL: https://github.com/RedHatWorkshops/argocd-getting-started
    targetRevision: main
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
  sync:
    comparedTo:
      destination:
        namespace: openshift-gitops
        server: https://kubernetes.default.svc
      source:
        path: resources/manifests/bgdk-yaml
        repoURL: https://github.com/RedHatWorkshops/argocd-getting-started
        targetRevision: main
```

Let's break this down a bit.

* ArgoCD's concept of a `Project` is different than OpenShift's. Here you're installing the application in ArgoCD's `default` project (`.spec.project`). **NOT** OpenShift's `default` project.
* The destination server is the server we installed ArgoCD on (noted as `.spec.destination.server`).
* The manifest repo where the YAML resides and the path to look for the YAML is under `.spec.source`.
* The `.spec.syncPolicy` is set to automatically sync the repo.
* The last section `.spec.sync` just says what are you comparing the repo to. (Basically "Compare the running config to the desired config")

The `Application` CR (`CustomResource`) can be applied using [this repo](resources/manifests/bgdk-app) by running:

`oc apply -k manifests/bgdk-appk`{{execute}}

This should create the `bgdk-appk` in the ArgoCD UI.

![bgdk-app](../../assets/gitops/bgdk-app.png)

Clicking on this takes you to the overview page. You may see it as still progressing or full synced. 

![synced-app](../../assets/gitops/synced-app.png)

> :heavy_exclamation_mark: **NOTE**: You may have to click on `show hidden resources` on this page to see it all

At this point the application should be up and running. You can see
all the resources created with the `oc get pods,svc,route -n bgd`{{execute}}
command. The output should look like this:

```
$ oc get pods,svc,route -n bgd
NAME                       READY   STATUS    RESTARTS   AGE
pod/bgd-788cb756f7-kz448   1/1     Running   0          10m

NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/bgd   ClusterIP   172.30.111.118   <none>        8080/TCP   10m

NAME                           HOST/PORT                                PATH   SERVICES   PORT   TERMINATION   WILDCARD
route.route.openshift.io/bgd   bgd-bgd.apps.example.com          bgd        8080                 None
```

Your output will be slightly different.

Visit your application by running the following to get the URL:

`oc get route bgd -n bgd -o jsonpath='{.spec.host}{"\n"}'`{{execute}}

Your application should look like this.

![bgd](../../assets/gitops/bgd.png)

Let's introduce a change! Patch the live manifest to change the color
of the box from blue to green:

`oc -n bgd patch deploy/bgd --type='json' \
-p='[{"op": "replace", "path": "/spec/template/spec/containers/0/env/0/value", "value":"green"}]'`{{execute}}

If you quickly (I'm not kidding, you have to be lightning fast or you'll
miss it) look at the screen you'll see it out of sync:

![outofsync](../../assets/gitops/out-of-sync.png)

But ArgoCD sees that difference and changes it back to the desired
state. Preventing drift.

![fullysynced](resources/images/fullysynced.png)

> :bulb: **NOTE**: If you're having touble catching the sync. Run your browser window and terminal window side-by-side. This is a good thing, that Argo acts so quickly. :smiley:
