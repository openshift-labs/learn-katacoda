<br>
# Application Deployment with Argo CD CLI

In this step we are going to deploy our [simple application](http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab/src/pre/reversewords_app/) into the clusters using ArgoCD CLI tool.

## Configuring Git Repository on Argo CD

Before configuring our applications into Argo CD, we need to configure the Git repository which contains the manifests used to deploy our applications:

1. Add the repository to Argo CD

    ``argocd repo add http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab.git``{{execute}}
2. Verify the repository has been loaded into Argo CD

    ``argocd repo list``{{execute}}

## Define the applications within Argo CD

The Git repository has been already defined, now it's time to move on and configure the applications on Argo CD:

1. Create the application on `preproduction` cluster using the previously defined git repository

    ``argocd app create --project default --name pre-reverse-words-app \
    --repo http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab.git \
    --path reversewords_app/base \
    --dest-server $(argocd cluster list | grep pre | awk '{print $1}') \
    --dest-namespace reverse-words \
    --revision pre --sync-policy automated``{{execute}}

    1. **--project** Argo CD Project where the app will be created
    2. **--name** Argo CD Application name
    3. **--repo** Git Repository defined withing Argo CD that will be used as source of truth
    4. **--path** Path within the Git Repository where the application manifests are stored
    5. **--dest-server** Kubernetes cluster where the application will be deployed
    6. **--dest-namespace** Kubernetes namespace where the application will be deployed
    7. **--revision** Git branch/reference used for getting the application sources
    8. **--sync-policy** If automated Argo CD will perform regular checks to ensure application state in Kubernetes matches the application definition in Git
2. Create the application on `production` cluster

    ``argocd app create --project default --name pro-reverse-words-app \
    --repo http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab.git \
    --path reversewords_app/base \
    --dest-server $(argocd cluster list | grep pro | awk '{print $1}') \
    --dest-namespace reverse-words \
    --revision pro --sync-policy automated``{{execute}}
3. List the newly defined applications

    ``argocd app list``{{execute}}
4. Get the applications status, they might have a status of _OutOfSync_, that would mean that manifests are still being created on the clusters, just give them a few seconds to complete

    * Preproduction: ``argocd app get pre-reverse-words-app``{{execute}}
    * Production: ``argocd app get pro-reverse-words-app``{{execute}}
5. You have to wait until the applications are reported `Healthy` by Argo CD before continuing with the lab

    ~~~sh
    <OUTPUT_OMMITED>
    Health Status:      Healthy
    ~~~

## Verify that the applications are running

Our application is composed of:

* A namespace
* A Deployment
* A Service

Let's verify those are created in the cluster.

1. Verify Namespace is created

    * Preproduction: ``oc --context pre get namespace reverse-words``{{execute}}
    * Production: ``oc --context pro get namespace reverse-words``{{execute}}
2. Verify Deployment is created

    * Preproduction: ``oc --context pre -n reverse-words get deployment``{{execute}}
    * Production: ``oc --context pro -n reverse-words get deployment``{{execute}}
3. Verify Service is created

    * Preproduction: ``oc --context pre -n reverse-words get service``{{execute}}
    * Production: ``oc --context pro -n reverse-words get service``{{execute}}
4. Expose a route and verify the application can be queried

    * Preproduction: ``oc --context pre -n reverse-words expose service reverse-words --name=reverse-words-pre``{{execute}}
    * Production: ``oc --context pro -n reverse-words expose service reverse-words --name=reverse-words-pro``{{execute}}
5. Query the application

    * Preproduction: ``curl -X POST http://$(oc --context pre -n reverse-words get route reverse-words-pre -o jsonpath='{.spec.host}') -d '{"word":"PALC"}'``{{execute}}
    * Production: ``curl -X POST http://$(oc --context pro -n reverse-words get route reverse-words-pro -o jsonpath='{.spec.host}') -d '{"word":"PALC"}'``{{execute}}

We have deployed our application to both clusters from a single tool (Argo CD). In the next steps we are going to explore how we can override some configurations depending on the destination cluster by using embedded `Kustomize` on Argo CD.

We created an OpenShift `Route` when we ran the `oc expose` command, this is not recommended since all our application manifest should live on Git, in the next steps we will fix that.