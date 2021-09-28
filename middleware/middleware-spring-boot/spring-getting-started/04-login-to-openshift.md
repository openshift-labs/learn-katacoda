# Login to OpenShift Container Platform

**Red Hat OpenShift Container Platform** is the preferred runtime for the **Red Hat Runtimes** like **Spring Boot**, **Vert.x** etc. The OpenShift Container Platform is based on **Kubernetes** which is a Container Orchestrator that has grown in popularity and adoption over the last years. **OpenShift** is currently the only container platform based on Kubernetes that offers multitenancy. This means that developers can have their own personal, isolated projects to test and verify application before committing to a shared code repository.

OpenShift also ships with a feature rich web console as well as command line tools to provide users with a friendly interface to work with applications deployed to the platform.

**1. Login to OpenShift Container Platform**

This sandbox has already authenticated you to OpenShift. To validate, we will use the `oc whoami` command:

``oc whoami``{{execute}}

**2. Create project**

[Projects](https://docs.openshift.com/container-platform/4.7/rest_api/project_apis/project-project-openshift-io-v1.html) are a top-level concept to help you organize your deployments. An OpenShift project allows a community of users (or a user) to organize and manage their content in isolation from other communities. Each project has its own resources, policies (who can or cannot perform actions), and constraints (quotas and limits on resources, etc.). Projects act as a wrapper around all the application services and endpoints you (or your teams) are using for your work.

For this scenario, let's create a project that you will use to house your applications.

``oc new-project dev --display-name="Dev - Spring Boot App"``{{execute}}

**3. Open the OpenShift Web Console**

OpenShift ships with a web-based console that will allow users to
perform various tasks via a browser. To get a feel for how the web console
works, click on the "OpenShift Console" tab next to the "Local Web Browser" tab.

![OpenShift Console Tab](/openshift/assets/middleware/rhoar-getting-started-spring/openshift-console-tab.png)

The first screen you will see is the authentication screen. Enter your username (developer) and password (developer) and
then login:

![Web Console Login](/openshift/assets/middleware/rhoar-getting-started-spring/login.png)

After you have authenticated to the web console, you will be presented with a list of projects that your user has permission to view.

![Web Console Projects](/openshift/assets/middleware/rhoar-getting-started-spring/projects.png)

Click on your new project name to be taken to the project overview page which will show you various options to add content to your project, create an application, component or service:

![Web Console Overview](/openshift/assets/middleware/rhoar-getting-started-spring/overview.png)

There's nothing there now, but that's about to change.

## Congratulations

You have now learned how to access your openshift environment.

In next step of this scenario, we will deploy our application to the OpenShift Container Platform.
