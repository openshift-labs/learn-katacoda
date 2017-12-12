### Command Line

To access OpenShift from the command line you need the `oc` command line tool. In this environment that tool has already been installed for you and is accessible from the _Terminal_ window to the right.

In order to login, run the following command:

``oc login``{{execute}}

In this interactive learning environment, whenever you see a command like that above which displays a carriage return icon to the right of the command, you can click on the command and it will be run for you in the _Terminal_ window automatically.

Once you run the `oc login` command, you will be prompted for the username and
password combination for your user account:

When prompted, enter the following username and password:

**Username:** ``developer``{{execute}}

**Password:** ``developer``{{execute}}

Once you have authenticated to the OpenShift server, you will see the
following confirmation message:

```
Login successful.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>
```

Congratulations, you are now authenticated to the OpenShift server. The
OpenShift master includes a built-in OAuth server. Developers and administrators
obtain OAuth access tokens to authenticate themselves to the API. By default
your authorization token will last for 24 hours.

### Using a project

Projects are a top level concept to help you organize your deployments. An
OpenShift project allows a community of users (or a user) to organize and manage
their content in isolation from other communities. Each project has its own
resources, policies (who can or cannot perform actions), and constraints (quotas
and limits on resources, etc). Projects act as a "wrapper" around all the
application services and endpoints you (or your teams) are using for your work.

The first thing we want to do is create the project to work in. Create the `myproject` project by running:

``oc new-project myproject``{{execute}}

You will see the following confirmation message:

```
Now using project "myproject" on server "https://172.17.0.45:8443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app centos/ruby-22-centos7~https://github.com/openshift/ruby-ex.git

to build a new example application in Ruby.
```

### The Web Console

OpenShift ships with a web-based console that will allow users to
perform various tasks via a browser.  In this interactive learning portal, to the right of this description you should initially see a terminal window. To access the web console, click on the _Dashboard_ button above the terminal window. You can switch back to the terminal by clicking on the _Terminal_ button.

The actual URL for the web console is:

https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com

If you click on this you will be taken to the _Dashboard_ tab. If you want to view the web console in a separate browser tab or window, right click on the URL and select the menu option to open it.

The first screen you will see in the web console is the authentication screen.

![Web Console Login](../../assets/intro-openshift/deploying-python/01-web-console-login.png)

Enter in the following credentials:

**Username:** ``developer``{{copy}}

**Password:** ``developer``{{copy}}

In this interactive learning environment, whenever you see text like that above which has the copy icon to the right of the text, you can click on it and it will be automatically copied into your copy/paste buffer. You can then copy it into any web console fields or the terminal window.

After you have authenticated to the web console, you will be presented with a
list of projects that your user has permission to work with. You will see
something that looks like the following image:

![List of Projects](../../assets/intro-openshift/deploying-python/01-list-of-projects.png)

Click on the `myproject` project. You will be taken to the project overview page
which will list all of the routes, services, deployments, and pods that you have
running as part of your project. There's nothing there now, but that's about to
change.

![Project Overview](../../assets/intro-openshift/deploying-python/01-project-overview.png)

We will be using a mix of command line tooling and the web console for this tutorial.
Get ready!
