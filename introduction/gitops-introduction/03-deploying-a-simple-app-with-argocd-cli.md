<br>
# Application Deployment with Argo CD CLI

In this step we are going to deploy our [simple application](http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab/src/master/simple-app/reversewords_app/) into the cluster using ArgoCD CLI tool.

## Configuring Git Repository on Argo CD

Before configuring our application into Argo CD, we need to configure the Git repository which contains the manifests used to deploy our applications:

1. Add the repository to Argo CD

    ``argocd repo add http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab.git``{{execute}}
2. Verify the repository has been loaded into Argo CD

    ``argocd repo list``{{execute}}

## Define the application within Argo CD

The Git repository has been already defined, now it's time to move on and configure the application on Argo CD:

1. Create the application using the previously defined git repository

    ``argocd app create --project default --name reverse-words-app \
    --repo http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab.git \
    --path simple-app/reversewords_app/ \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace reverse-words \
    --revision master --sync-policy automated``{{execute}}

    1. **--project** Argo CD Project where the app will be created
    2. **--name** Argo CD Application name
    3. **--repo** Git Repository defined withing Argo CD that will be used as source of truth
    4. **--path** Path within the Git Repository where the application manifests are stored
    5. **--dest-server** Kubernetes cluster where the application will be deployed
    6. **--dest-namespace** Kubernetes namespace where the application will be deployed
    7. **--revision** Git branch/reference used for getting the application sources
    8. **--sync-policy** If automated Argo CD will perform regular checks to ensure application state in Kubernetes matches the application definition in Git
2. List the newly defined application

    ``argocd app list``{{execute}}
3. Get the application status, it might have a status of _OutOfSync_, that would mean that manifests are still being created on the cluster, just give it a few seconds to complete

    ``argocd app get reverse-words-app``{{execute}}
4. You have to wait until the application is reported `Healthy` by Argo CD before continuing with the lab

    ~~~sh
    <OUTPUT_OMMITED>
    Health Status:      Healthy
    ~~~

## Verify that the application is running

Our application is composed of:

* A namespace
* A Deployment
* A Service

Let's verify those are created in the cluster.

1. Verify Namespace is created

    ``oc get namespace reverse-words``{{execute}}
2. Verify Deployment is created

    ``oc -n reverse-words get deployment``{{execute}}
3. Verify Service is created

    ``oc -n reverse-words get service``{{execute}}
4. Expose a route and verify the application can be queried

    ``oc -n reverse-words expose service reverse-words``{{execute}}
5. Query the application

    ``curl -X POST http://$(oc -n reverse-words get route reverse-words -o jsonpath='{.spec.host}') -d '{"word":"PALC"}'``{{execute}}

# State Recovery

We are going to delete the deployment and watch how Argo CD will notice the deletion and act towards creating the deployment again.

``oc -n reverse-words delete deployment reverse-words``{{execute}}

The deployment is now missing, let's see if Argo CD has noticed it:

``argocd app list``{{execute}}

You should see something like this:

~~~
NAME               CLUSTER                         NAMESPACE          PROJECT  STATUS     HEALTH   SYNCPOLICY  CONDITIONS
reverse-words-app  https://kubernetes.default.svc  reverse-words-app  default  OutOfSync  Missing  Automated   <none>
~~~

Let's force a sync (it might happen that Argo CD already synched the app as the sync policy was set to `Automated`):

``argocd app sync reverse-words-app``{{execute}}

After running the sync command we will see an error message:

`FATA[000X] 1 resources require pruning`

That has been caused by the OpenShift `Route` that was created when we ran the `oc expose` command as it is not stored in the Git repository. If auto-pruning had been enabled, the route would have been deleted. We will create the Route within Git in the next lab.

This error demonstrates the importance of keeping all of the Kubernetes objects within Git to ensure that there is no configuration drift.

Verify the deployment is created after the synchronization has completed:

``oc -n reverse-words get deployment``{{execute}}
