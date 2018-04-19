**Red Hat OpenShift Container Platform** is the preferred runtime for the **Red Hat OpenShift Application Runtimes**
like **Node.js**. OpenShift Container Platform is based on **Kubernetes** which is the most used Orchestration
for containers running in production. **OpenShift** is currently the only container platform based on Kubernetes
that offers multi-tenancy. This means that developers can have their own personal isolated projects to test and
verify applications before committing them to a shared code repository.

OpenShift also ships with a feature rich web console as well as command line tools to provide users with a nice
interface to work with applications deployed to the platform.

**1. Login to OpenShift Container Platform**

In order to login, we will use the **oc** command and then specify the server that we
want to authenticate to:

`oc login [[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com --insecure-skip-tls-verify=true`{{execute}}

Enter your username and password:
* Username: **developer**
* Password: **developer**

Congratulations, you are now authenticated to the OpenShift server.

> If the above `oc login` command doesn't seem to do anything, you may have forgotten to stop the application from the previous
step. Click in the terminal and press CTRL-C to stop the application and try to `oc login` again!

**2. Create project**

[Projects](https://docs.openshift.com/container-platform/3.6/architecture/core_concepts/projects_and_users.html#projects)
are a top level concept to help you organize your deployments. An
OpenShift project allows a community of users (or a user) to organize and manage
their content in isolation from other communities. Each project has its own
resources, policies (who can or cannot perform actions), and constraints (quotas
and limits on resources, etc). Projects act as a wrapper around all the
application services and endpoints you (or your teams) are using for your work.

For this scenario, let's create a project that you will use to house your applications.

```oc new-project example --display-name="Sample Node.js External Config App"```{{execute}}

**3. Open the OpenShift Web Console**

OpenShift ships with a web-based console that will allow users to
perform various tasks via a browser. To get a feel for how the web console
works, click on the "OpenShift Console" tab next to the "Local Web Browser" tab.

![OpenShift Console Tab](/openshift/assets/middleware/rhoar-getting-started-nodejs/openshift-console-tab.png)

The first screen you will see is the authentication screen. Enter your username and password and
then log in:

![Web Console Login](/openshift/assets/middleware/rhoar-getting-started-nodejs/login.png)

After you have authenticated to the web console, you will be presented with a
list of projects that your user has permission to work with.

![Web Console Projects](/openshift/assets/middleware/rhoar-getting-started-nodejs/projects.png)

Click on your new project name to be taken to the project overview page
which will list all of the routes, services, deployments, and pods that you have
running as part of your project:

![Web Console Overview](/openshift/assets/middleware/rhoar-getting-started-nodejs/overview.png)

There's nothing there now, but that's about to change.
