Before we get started, please make sure that you have completed all steps of the Red Hat Fuse Hello World guide.  All set?  Let’s get your OpenShift environment up and running ..

# Setup OpenShift

To login to the OpenShift use the following command in the **_Terminal_** frame:

``oc login -u developer -p developer``{{execute}}

This will log you in using the credentials:

* **Username:** ``developer``
* **Password:** ``developer``

You should see the output:

```
Login successful.

Now we need to create a Project space in OpenShift for our API.  In OpenShift we can create a new project by running

    oc new-project <projectname>
```

For our project lets create a project called ``fuselab`` by running the command:

``oc new-project fuselab``{{execute}}

You should see output similar to:

```
Now using project "fuselab" on server "https://172.17.0.41:8443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app centos/ruby-22-centos7~https://github.com/openshift/ruby-ex.git

to build a new example application in Ruby.
```

Now switch to the **_Dashboard_** frame (Click on the tab next to the Terminal tab) and login to the OpenShift web console using the
same credentials you used above.

![Web Console Login](../../assets/middleware/fuse-hello-world/01-web-console-login.png)

This should take you to the list of projects you have access to. As we only
created the one project, all you should see is ``fuselab``.

![List of Projects](../../assets/middleware/fuse-hello-world/01-list-of-projects.png)

Click on ``fuselab `` to be taken to the **_Overview_** page for ``fuselab``.

![Project Overview](../../assets/middleware/fuse-hello-world/01-project-overview.png)

At this point, your project is empty. Click **_Continue_** to see how to deploy your first application.
