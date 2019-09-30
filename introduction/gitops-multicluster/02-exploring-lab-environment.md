The lab environment is composed by:

* Two OpenShift 3.11 clusters, `preproduction` and `production`.
* Argo CD deployed on `argocd` namespace in `preproduction` cluster and WebUI available through the `ArgoCD Server` tab next to the terminal.
* Gogs server deployed on `gogs` namespace in `preproduction` cluster and WebUI available through the `Gogs Server` tab next to the terminal.
* A Git repository named `gitops-lab` which has our application manifests pre-loaded.

## Users and Passwords

**Argo CD Server**

* _Username:_ admin
* _Password:_ student

**Gogs Server**

* _Username:_ student
* _Password:_ student

## Explore the Application Sources

The application sources can be found in the Git repository created on Gogs Server, there are two branches, one per environment, to access them directly click the links below:

* [Preproduction](http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab/src/pre/reversewords_app)
* [Production](http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab/src/pro/reversewords_app)

## Getting to know Argo CD CLI

Argo CD Cli tool has been pre-installed for you. You should be able to manage Argo CD applications from the console using the cli.

During the lab initialization we created an authentication token for the CLI which is already in use so you don't need to authenticate again.

One thing that you should keep in mind is that as we are using OpenShift `Routes` to access `Argo CD Server`, we need to specify the flag `--grpc-web` when login into Argo CD so the grpc calls are encapsulated in HTTP, otherwise commands will fail as OpenShift Routers don't support grpc as of now.

``argocd --help``{{execute}}

### Login into ArgoCD Server from CLI

> **NOTE:** The steps below have been already performed during lab initialization, so we're visiting them just for reference:

~~~sh
argocd --insecure --grpc-web login \
argocd-server-argocd.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com:443 \
--username admin --password <argocd-server-pod-name>
~~~

### Update ArgoCD Admin Password from CLI

> **NOTE:** The steps below have been already performed during lab initialization, so we're visiting them just for reference:

~~~sh
argocd --insecure --grpc-web \
--server argocd-server-argocd.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com:443 \
account update-password --current-password <argocd-server-pod-name> \
--new-password student
~~~

### Add Cluster to Argo CD

> **NOTE:** The steps below have been already performed during lab initialization, so we're visiting them just for reference:

`pre` and `pro` are references to `contexts` created on the `oc` tool. More info around contexts [here](https://docs.openshift.com/container-platform/3.11/cli_reference/manage_cli_profiles.html).

~~~sh
argocd cluster add pre
argocd cluster add pro
~~~

## List available clusters

``argocd cluster list``{{execute}}

You will see that we have two clusters ready to be used:

* `pro` will be our production cluster
* `pre` will be our preproduction cluster
  
> **NOTE:** `kubernetes.default.svc` is the default cluster created by Argo CD that refers to the cluster where Argo CD is running (preproduction in this case)

```sh
SERVER                          NAME  STATUS      MESSAGE
https://172.17.0.13:8443        pro   Successful
https://172.17.0.22:8443        pre   Successful
https://kubernetes.default.svc        Successful
```
