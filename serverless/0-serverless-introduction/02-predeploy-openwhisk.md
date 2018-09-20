# Preparing to Deploy Apache OpenWhisk to OpenShift

During this step of the scenario, you will learn how to prepare for the deployment of the **Apache OpenWhisk** Serverless
platform to **OpenShift Container Platform**.

**1. Create project**

Let's create a project that you will use to house the OpenWhisk containers:

``oc new-project faas --display-name="FaaS- Apache OpenWhisk"``{{execute}}

**2. Add developer as admin to `faas` project**

Since we will be using the user called `developer` throught this scenario it will be ideal to add `admin` role to the
user `developer` to peform required tasks without switching user.

``oc adm policy add-role-to-user admin developer -n faas``{{execute}}

**3. Open the OpenShift Web Console**

OpenShift ships with a web-based console that will allow users to perform various tasks via a browser. To get a feel for how
the web console works, click on the "OpenShift Console" tab next to the "Local Web Browser" tab.

![OpenShift Console Tab](/openshift/assets/serverless/0-serverless-introduction/openshift-console-tab.png)

The first screen you will see is the authentication screen. Enter your username and password to login.  The default credential
is `developer/developer`:

![Web Console Login](/openshift/assets/serverless/0-serverless-introduction/login.png)

After you have authenticated to the web console, you will be presented with a list of projects that your user has permission to view.

![Web Console Projects](/openshift/assets/serverless/0-serverless-introduction/projects.png)

Click on your new project name to be taken to the project overview page which will list all of the routes, services, deployments,
and pods that you have created as part of your project.

## Congratulations

You have now prepared OpenShift environment for deploying Apache OpenWhisk. 

In next step of this scenario, you will deploy [Apache OpenWhisk](https://openwhisk.apache.org/) to the
[OpenShift Container Platform](https://openshift.com]).
