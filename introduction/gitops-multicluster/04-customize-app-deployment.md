<br>
# Customize Application Deployments with Argo CD and Kustomize

In the previous step we have deployed our simple application to multiple clusters, in this lab we are going to customize the deployment based on the destination cluster.

We will setup a different release name for our application, on top of that, we are going to include an OpenShift `Route` manifest to the Git repository so all our application
manifests live in Git.

Argo CD has a built-in [Kustomize](https://kustomize.io/) feature, we are going to use it in order to control which changes we send to our clusters based on the environment we are deploying to.

## Reviewing Kustomized files

It can take some time for these files to be processed and created. Proceed once all of the files linked in the two lists below are present in the project git repository.

* Preproduction Files
  * [Base Route File](http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab/src/pre/reversewords_app/base/route.yaml)
  * [Kustomized Route File](http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab/src/pre/reversewords_app/overlays/pre/route.yaml)
  * [Base Deployment File](http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab/src/pre/reversewords_app/base/deployment.yaml)
  * [Kustomized Deployment File](http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab/src/pre/reversewords_app/overlays/pre/deployment.yaml)
* Production Files
  * [Base Route File](http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab/src/pro/reversewords_app/base/route.yaml)
  * [Kustomized Route File](http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab/src/pro/reversewords_app/overlays/pro/route.yaml)
  * [Base Deployment File](http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab/src/pro/reversewords_app/base/deployment.yaml)
  * [Kustomized Deployment File](http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab/src/pro/reversewords_app/overlays/pro/deployment.yaml)

Basically what is going to happen is:

Argo CD will load the base files and then will apply the customization defined for each file in the overlays/[pre/pro]/folder:

* Deployment: The Kustomized deployment sets a different release name
* Route: The Kustomized route sets a hostname valid for the cluster where it will be deployed

## Deploying the Kustomized Applications

1. Deploy the application on `preproduction` cluster

    ``argocd app create --project default --name pre-kustomized-reverse-words-app \
    --repo http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab.git \
    --path reversewords_app/overlays/pre \
    --dest-server $(argocd cluster list | grep pre | awk '{print $1}') \
    --dest-namespace reverse-words \
    --revision pre --sync-policy automated``{{execute}}
2. Deploy the application on `production` cluster

    ``argocd app create --project default --name pro-kustomized-reverse-words-app \
    --repo http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab.git \
    --path reversewords_app/overlays/pro \
    --dest-server $(argocd cluster list | grep pro | awk '{print $1}') \
    --dest-namespace reverse-words \
    --revision pro --sync-policy automated``{{execute}}
3. List the newly defined applications

    ``argocd app list``{{execute}}
4. Get the applications status, they might have a status of _OutOfSync_, that would mean that manifests are still being created on the clusters, just give them a few seconds to complete

    * Preproduction: ``argocd app get pre-kustomized-reverse-words-app``{{execute}}
    * Production: ``argocd app get pro-kustomized-reverse-words-app``{{execute}}
5. You have to wait until the applications are reported `Healthy` by Argo CD before continuing with the lab

    ~~~sh
    <OUTPUT_OMMITED>
    Health Status:      Healthy
    ~~~

## Accessing our Applications

Now based on the cluster we access we should see a different release:

* Preproduction: ``curl -k http://$(oc --context pre -n reverse-words get route reverse-words -o jsonpath='{.spec.host}')``{{execute}}
* Production: ``curl -k http://$(oc --context pro -n reverse-words get route reverse-words -o jsonpath='{.spec.host}')``{{execute}}

Using Kustomize we have been able to deploy to multiple clusters and use custom configurations depending on which cluster we are using to deploy the application. In the next section we are going to explore how we can use GitOps to perform a basic canary deployment.