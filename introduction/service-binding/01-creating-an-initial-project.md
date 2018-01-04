Before we get started, you need to login and create a project in OpenShift
to work in.

To login to the OpenShift cluster used for this course from the _Terminal_,
run:

``oc login -u developer -p developer``{{execute}}

This will log you in using the credentials:

* **Username:** ``developer``
* **Password:** ``developer``

You should see the output:

```
Login successful.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>
```

To create a new project called ``myproject`` run the command:

``oc new-project myproject``{{execute}}

You should see output similar to:

```
Now using project "myproject" on server "https://172.17.0.41:8443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app centos/ruby-22-centos7~https://github.com/openshift/ruby-ex.git

to build a new example application in Ruby.
```

Switch to the _Dashboard_ and login to the OpenShift web console using the
same credentials you used above.

![Web Console Login](../../assets/introduction/service-binding/01-web-console-login.png)

This should leave you at the service catalog. You should also see listed to the right the project ``myproject`` which you created.

![Service Catalog](../../assets/introduction/service-binding/01-service-catalog.png)
