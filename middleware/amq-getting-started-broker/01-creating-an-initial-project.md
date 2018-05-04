To get started, first we need to login to OpenShift.

To login to the OpenShift cluster use the following commmand in your **_Terminal_**:

``oc login -u developer -p developer [[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com --insecure-skip-tls-verify=true``{{execute}}

> You can click on the above command (and all others in this scenario) to automatically copy it into the terminal and execute it.

This will log you in using the credentials:

* **Username:** ``developer``
* **Password:** ``developer``

You should see the output:

```
Login successful.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>
```

For this scenario lets create a project called ``messaging`` by running the command:

``oc new-project messaging``{{execute}}

You should see output similar to:

```
Now using project "messaging" on server "https://172.17.0.41:8443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app centos/ruby-22-centos7~https://github.com/openshift/ruby-ex.git

to build a new example application in Ruby.
```

In the next, you will deploy a new instance of the AMQ broker.