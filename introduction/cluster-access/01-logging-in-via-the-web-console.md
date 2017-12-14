The easiest way to access and interact with OpenShift is through the web console. The URL for the web console will be dictated by what was specified as the public URL for the OpenShift cluster when it was set up. Once the web console is accessed, how you then login will depend on the configured identity provider.

For this course the public URL for the web console is:

``https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com``{{copy}}

To view the web console at the same time as these instructions, you can also select the _Dashboard_ tab to the right of the tab for the embedded _Terminal_.

In the case of the OpenShift cluster managing user authentication, the web console login page will prompt you for your _Username_ and _Password_.

![Web Console Login](../../assets/introduction/cluster-access/01-web-console-login.png)

In the case of an external authentication service being used as the identity provider, it will be necessary to login first to the external service. As an example, if you were accessing [OpenShift Online](https://www.openshift.com/get-started/) you would see:

![External Login](../../assets/introduction/cluster-access/01-external-identity-provider.png)

For the OpenShift cluster used in this course, as the OpenShift cluster is managing user authentication, you will be presented with a login page that prompts you for your user account credentials. You can login using the credentials:

* **Username:** ``developer``
* **Password:** ``developer``

As this is the first time you have logged in as this user in this OpenShift cluster, you will be presented with a "Welcome to OpenShift" message and the option of creating a new project.

![Web Console Welcome](../../assets/introduction/cluster-access/01-web-console-welcome.png)

Create a new project by selecting _New Project_. Call the project ``myproject``.

![Create New Project](../../assets/introduction/cluster-access/01-create-new-project.png)

When a new project is created you will be shown a catalog of application types you can deploy. To skip creating any application at this point and get to main page with the list of all projects you have, you can select on the name of the OpenShift product found at the top left of the page.

![Shortcut to Projects](../../assets/introduction/cluster-access/01-shortcut-to-projects.png)

Click on the logo now to return to the main page.

This is useful if you ever got lost in the web console and want to get back to the top most level.

![List of Projects](../../assets/introduction/cluster-access/01-list-of-projects.png)
