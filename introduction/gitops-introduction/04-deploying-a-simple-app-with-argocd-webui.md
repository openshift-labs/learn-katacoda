<br>
# Aplication Deployment with Argo CD

In this step we are going to deploy our [simple application](http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab/src/master/simple-app/reversewords_app/) into the cluster using the ArgoCD WebUI.

## Adding application Route to the Git Repository

In the previous lab we have seen how Argo CD detected that the OpenShift Route created by the `oc expose` command was not available in the Git repository, we are going to fix this by adding the route definition to the Git repository.

1. Explore the OpenShift Route definition file (it was created for you during lab initialization)

    ``cat ~/route.yaml``{{execute}}
2. Add the `route.yaml` to the git repository

    ``cp ~/route.yaml ~/gitops-lab/simple-app/reversewords_app/``{{execute}}
3. Commit new changes and push them to the Git remote

    ``
    cd ~/gitops-lab/
    git add simple-app/reversewords_app/route.yaml
    git commit -m "Added application route definition"
    git push origin master
    ``{{execute}}
4. Now your changes are available on Git, you can go ahead and browse the repository and confirm that the `route.yaml` is now available.

   * http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab/src/master/simple-app/reversewords_app/

## Configuring Git Repository on Argo CD WebUI

> **NOTE:** We need to cleanup previous lab, we have an script that will delete lab3 work

``clean-lab3``{{execute}}

Before configuring our application into Argo CD, we need to configure the Git repository which contains the manifests used to deploy our applications:

1. Make sure you have cleaned the previous lab work by executing the script above
2. Login into the [ArgoCD WebUI](https://argocd-server-argocd.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com)
   1. **User:** admin
   2. **Pwd:** student
3. Click on the Gears icon on the left menu
4. Click on `Repositories`
5. Click on `Connect repo using https`
6. Introduce `http://gogs.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/student/gitops-lab.git` as the repository URL
7. Leave the other fields empty and click `Connect`
8. Now you will see the repository definition with connection status reporting `Successful`

## Define the application within Argo CD WebUI

Now it's time to define our application using the Argo CD WebUI:

1. Click on the Boxes icon on the left menu
2. Click on `Create application`
   1. **Application Name:** reverse-words-app
   2. **Project:** default
   3. **Sync Policy:** Automatic
   4. **Repository URL:** (Dropdown) Select the repository you created in the previous step
   5. **Revision:** master
   6. **Path:** simple-app/reversewords_app/
   7. **Cluster:** (Dropdown) Select `in-cluster kubernetes.default.svc`
   8. **Namespace:** reverse-words
   9. **Include Subdirectories:** Leave unchecked
3. Click on `Create`
4. Once the application is synched you can go ahead and check the status withing the WebUI
    1. The app status will be reported in the Application section (hit refresh if you can't see the application)
   
    ![Argo CD App 1](gitops-introduction/assets/argocd-app1.png)
    2. If you click on the application, you will get to the detailed view

    ![Argo CD App 2](gitops-introduction/assets/argocd-app2.png)

## Verify that the application is running

As we did in the previous lab we are going to verify that the different objects have been created in the cluster.

1. Verify Namespace is created

    ``oc get namespace reverse-words``{{execute}}
2. Verify Deployment is created

    ``oc -n reverse-words get deployment``{{execute}}
3. Verify Service is created

    ``oc -n reverse-words get service``{{execute}}
4. Verify Route is created

    ``oc -n reverse-words get route``{{execute}}
5. Query the application

    ``curl -k -X POST https://$(oc -n reverse-words get route reverse-words -o jsonpath='{.spec.host}') -d '{"word":"PALC"}'``{{execute}}
