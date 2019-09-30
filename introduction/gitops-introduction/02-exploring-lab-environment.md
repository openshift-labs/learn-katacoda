The lab environment is composed by:

* An OpenShift 3.11 cluster.
* Argo CD deployed on `argocd` namespace and WebUI available through the `ArgoCD Server` tab next to the terminal.
* Gogs server deployed on `gogs` namespace and WebUI available through the `Gogs Server` tab next to the terminal.
* A Git repository named `gitops-lab` which has our application manifests pre-loaded.

## Users and Passwords

**Argo CD Server**

* _Username:_ admin
* _Password:_ student

**Gogs Server**

* _Username:_ student
* _Password:_ student

## Explore the Application Sources

The application sources can be found in the Git repository created on Gogs Server, to access them directly click the link below:

http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab/src/master/simple-app/reversewords_app/


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

## List available clusters

``argocd cluster list``{{execute}}

You will see that the local cluster (where Argo CD is running) is already registered and ready to be used:

```sh
SERVER                          NAME  STATUS      MESSAGE
https://kubernetes.default.svc        Successful  
```
