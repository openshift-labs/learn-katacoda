# Login and Deploy to OpenShift Container Platform

**Red Hat OpenShift Container Platform** is the preferred runtime for **Red Hat OpenShift Application Runtimes** like **Spring Boot**, **Vert.x**, etc. The OpenShift Container Platform is based on **Kubernetes** which is a Container Orchestrator that has grown in popularity and adoption over the last couple years. **OpenShift** is currently the only container platform based on Kubernetes that offers multitenancy. This means that developers can have their own personal, isolated projects to test and verify applications before committing to a shared code repository.

OpenShift also ships with a feature rich web console as well as command line tools to provide users with a friendly interface to work with applications deployed to the platform. 

**1. Login to the OpenShift Container Platform**

To login, we will use the `oc` command with the developer credentials:

``oc login [[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com --insecure-skip-tls-verify=true -u developer -p developer``{{execute interrupt}}

>**IMPORTANT:** If the above `oc login` command doesn't seem to do anything, you may have forgotten to stop the application from the previous step. Click on the terminal and press <kbd>CTRL</kbd>+<kbd>C</kbd> to stop the application and try the above `oc login` command again!

Then we'll create the project:

``oc new-project dev --display-name="Dev - Spring Boot App"``{{execute}}

All that's left is to run the following command to deploy the application to OpenShift:

``mvn package fabric8:deploy -Popenshift``{{execute}}

After deployment completes either go to the OpenShift web console and click on the route or click [here](http://rhoar-training-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/fruits). We can confirm that our application is still up and working just as it was before! The only difference now is that it's deployed on OpenShift.

## Congratulations

You have now learned how to deploy a Spring Boot MVC application to OpenShift Container Platform. In the next step we will alter the application and re-deploy.

