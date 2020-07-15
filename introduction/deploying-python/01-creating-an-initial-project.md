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
Now using project "myproject" on server "https://openshift:6443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app django-psql-example

to build a new example application in Python. Or use kubectl to deploy a simple Kubernetes application:

    kubectl create deployment hello-node --image=gcr.io/hello-minikube-zero-install/hello-node
```

Switch to the _Console_ and login to the OpenShift web console using the
same credentials you used above.

![Web Console Login](../../assets/introduction/deploying-python-44/01-web-console-login.png)

This should leave you at the list of projects you have access to. As we only
created the one project, all you should see is ``myproject``.

![List of Projects](../../assets/introduction/deploying-python-44/01-list-of-projects.png)

Click on ``myproject`` and you should then be at the _Overview_ page for
the project. Select the _Developer_ perspective for the project instead of the _Adminstrator_ perspective in the left hand side menu. If necessary click on the hamburger menu icon top left of the web console to expose the left hand side menu.

![Add to Project](../../assets/introduction/deploying-images-44/01-add-to-project.png)


As the project is currently empty, no workloads should be found and you will be presented with various options for how you can deploy an application.
