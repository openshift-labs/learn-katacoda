## Red Hat OpenShift Container Platform

Red Hat OpenShift Container Platform is the preferred runtime for the Red Hat OpenShift Application Runtimes like Vert.x. OpenShift Container Platform is based on Kubernetes which is probably the most used Orchestration for containers running in production. OpenShift is currently the only container platform based on Kuberenetes that offers multitenancy. This means that developers can have their own personal, isolated projects to test and verify application before committing to a shared code repository.

OpenShift also ships with a feature rich web console as well as command line tools to provide users with a friendly interface to work with applications deployed to the platform.

**1. Login to OpenShift Container Platform**

Do this in the 1st terminal. To login, we will use the oc command and then specify username and password like this:

`oc login https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com -u developer -p developer --insecure-skip-tls-verify=true`{{execute interrupt}}

Congratulations, you are now authenticated to the OpenShift server.

**IMPORTANT**: If the above oc login command doesn't seem to do anything, you may have forgotten to stop the application from the previous step. Click on the terminal and press CTRL-C to stop the application and try the above oc login command again!

**2. Create project**

Projects are a top-level concept to help you organize your deployments. An OpenShift project allows a community of users (or a user) to organize and manage their content in isolation from other communities. Each project has its own resources, policies (who can or cannot perform actions), and constraints (quotas and limits on resources, etc.). Projects act as a wrapper around all the application services and endpoints you (or your teams) are using for your work.

For this scenario, let's create a project that you will use to house your applications.

`oc new-project vertx-kubernetes-workshop`{{execute}}

`oc policy add-role-to-group edit system:serviceaccounts -n vertx-kubernetes-workshop`{{execute}}

The first instruction creates the project. The second instruction grants permissions in order to use all the OpenShift capabilities.

**3. Open the OpenShift Web Console**

OpenShift ships with a web-based console that will allow users to perform various tasks via a browser. To get a feel for how the web console works, click on the "OpenShift Console" tab next to the "Local Web Browser" tab.

![OpenShift Console Tab](/openshift/assets/middleware/rhoar-getting-started-vertx/openshift-console-tab.png)

Login with the following credentials:

* Username: `developer`
* Password: `developer`
  
You should see the newly created project. Click on it. It’s empty, so let’s deploy our first application.
