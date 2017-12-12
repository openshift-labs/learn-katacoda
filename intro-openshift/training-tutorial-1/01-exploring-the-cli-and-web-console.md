## Lab: Exploring the CLI and Web Console

### Command Line

The first thing we want to do to ensure that our `oc` command line tools was
installed and successfully added to our path is login to the OpenShift
environment that has been provided for this Roadshow session.  In
order to login, we will use the `oc` command and then specify the server that we
want to authenticate to.  Issue the following command:

``oc login``

Once you issue the `oc login` command, you will be prompted for the username and
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
your authorization token will last for 24 hours. There is more information about
the login command and its configuration in the [OpenShift Documentation](https://docs.openshift.org/cli_reference/get_started_cli.html#basic-setup-and-login).

### Using a project

Projects are a top level concept to help you organize your deployments. An
OpenShift project allows a community of users (or a user) to organize and manage
their content in isolation from other communities. Each project has its own
resources, policies (who can or cannot perform actions), and constraints (quotas
and limits on resources, etc). Projects act as a "wrapper" around all the
application services and endpoints you (or your teams) are using for your work.
For this first lab, we are going to use a project named *smoke* that has been
created and populated with an application for you.

During this lab, we are going to use a few different commands to make sure that
things in the environment are working as expected.  Don't worry if you don't
understand all of the terminology as we will cover it in detail in later labs.

The first thing we want to do is create a project to work in. Create a project by running:

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
perform various tasks via a browser.  In this interactive learning portal, to the right of this description you should initially see a terminal window. To access the web console, click on the _Dashboard_ button about the terminal window. You can switch back to the terminal by clicking on the _Terminal_ button.

If you want to access the web console from a separate browser tab, you can also visit:

https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com

The first screen you will see is the authentication screen.

![Web Console Login](../../assets/intro-openshift/deploying-python/01-web-console-login.png)

Enter in the following credentials:

**Username:** ``developer``{{copy}}

**Password:** ``developer``{{copy}}

After you have authenticated to the web console, you will be presented with a
list of projects that your user has permission to work with. You will see
something that looks like the following image:

![List of Projects](../../assets/intro-openshift/deploying-python/01-list-of-projects.png)

Click on the ``myproject project. You will be taken to the project overview page
which will list all of the routes, services, deployments, and pods that you have
running as part of your project. There's nothing there now, but that's about to
change.

![Project Overview](../../assets/intro-openshift/deploying-python/01-project-overview.png)

We will be using a mix of command line tooling and the web console for the labs.
Get ready!
