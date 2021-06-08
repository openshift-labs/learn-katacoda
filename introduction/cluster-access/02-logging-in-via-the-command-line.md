The OpenShift web console provides a convenient method for quickly interacting with and viewing the state of applications you have deployed using OpenShift. Not everything you may want to do can be done through the web console. You will therefore also need to be familiar with using the OpenShift command line tool ``oc``.

In this course the embedded _Terminal_ provided to you already has ``oc`` installed so you do not need to download and install the ``oc`` client.

If you were using a different OpenShift cluster and did not already have the ``oc`` command line tool, you can download it by following the links in the _Command Line Tools_ menu option of the web console.

![Command Line Tools](../../assets/introduction/cluster-access-44/02-command-line-tools.png)

A link to details on where to get the command line tools was also shown on the initial welcome page when you first accessed the cluster when there were no projects.

Once you get to the list of downloads, you would need to download the archive specific to your platform, extract the ``oc`` binary and install it.

To login to the OpenShift cluster used for this course run in the terminal:

``oc login -u developer -p developer``{{execute}}

You should see output similar to:

```
Authentication required for https://openshift:6443 (openshift)
Login successful.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>
```

Next, create a new project namespace:

``oc new-project myproject``{{execute}}

You can list all the projects you currently have access to by running:

``oc get projects``{{execute}}

Once logged in, you can verify what user you are logged in by running:

``oc whoami``{{execute}}

You can verify which server you are logged into by running:

``oc whoami --show-server``{{execute}}

In the case of an external authentication service being used as the identity provider, the required steps are a bit different.

If you login using ``oc login`` on the command line you will be presented with an error message similar to:

```
Login failed (401 Unauthorized)
You must obtain an API token by visiting
  https://api.starter-us-east-1.openshift.com/oauth/token/request
```

You would visit the link given, logging in first via the separate authentication service if necessary. You will then be redirected to a page which will give details of the login command to use. This will include an access token to authenticate you for the session.

Even in the case where user authentication is managed by the OpenShift cluster and user credentials are accepted, you can opt to instead use an access token. You can retrieve the command to run by manually entering the ``/oauth/token/request`` path against the URL for the cluster access endpoint.

If you are already logged into the web console, you can also retrieve the details of the login command and access token by accessing the _Copy Login Command_ menu option under your login name.

 ![Request Access Token](../../assets/introduction/cluster-access-44/02-login-access-token.png)

Whichever mechanism you use to login from the command line using ``oc login``, the login will periodically expire and you will need to login again. The expiration period is typically 24 hours.
