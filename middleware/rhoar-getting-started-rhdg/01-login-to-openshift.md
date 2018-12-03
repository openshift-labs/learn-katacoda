**Red Hat OpenShift Container Platform** is the preferred runtime for Red Hat Data Grid and is based on the **Kubernetes** container-orchestration system.

If you are new to OpenShift, you should complete [Introduction to OpenShift]( https://learn.openshift.com/introduction/) before you start this tutorial.


**1. Logging in to OpenShift**

Run the **oc login** command as follows:

`oc login -u developer -p developer`{{execute}}

This command authenticates you to OpenShift with the following credentials:
* Username: **developer**
* Password: **developer**

**2. Creating a project**

Create a [project](https://docs.openshift.com/container-platform/3.6/architecture/core_concepts/projects_and_users.html#projects) for your RHDG application as follows:

`oc new-project example --display-name="Simple RHDG REST App"`{{execute}}

**3. Opening the OpenShift console**

OpenShift provides a console that lets you work with application deployments from a browser window.

1. Select the "OpenShift Console" tab to launch the console in your browser.
+
![OpenShift Console Tab](https://raw.githubusercontent.com/vblagoje/intro-katacoda/master/assets/middleware/rhoar-getting-started-rhdg/openshift-console-tab.png)

2. Enter your credentials when prompted to authenticate and then select "Log in".
+
![Web Console Login](https://raw.githubusercontent.com/vblagoje/intro-katacoda/master/assets/middleware/rhoar-getting-started-rhdg/login.png)
+
The console displays the projects that you can work with.
+
![Web Console Projects](https://raw.githubusercontent.com/vblagoje/intro-katacoda/master/assets/middleware/rhoar-getting-started-rhdg/projects.png)

3. Select the "Simple RHDG REST App" project that you created to view all of the resources available in your project:
+
![Web Console Overview](https://raw.githubusercontent.com/vblagoje/intro-katacoda/master/assets/middleware/rhoar-getting-started-rhdg/overview.png)

At the moment your project does not have any available applications or resources. Proceed to the next section and start creating a deployment.
