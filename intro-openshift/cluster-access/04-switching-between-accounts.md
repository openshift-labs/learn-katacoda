When using the ``oc`` command line tool, you can only interact with one OpenShift cluster at a time. It is not possible to open a separate shell on the same computer, as the same local user, and work on a different OpenShift cluster at the same time. This is because state about the current login session is stored in the home directory of the local user running the ``oc`` command.

If you do need to work against multiple OpenShift clusters, or even as different users on the same OpenShift cluster, you will need to remember to switch between them.

In this course you originally logged in from the command line using ``oc login`` as the ``developer`` user. You then subsequently logged in as the ``collaborator`` user.

At this point you are still logged in and have an active session token for both users, but are currently operating as the ``collaborator`` user.

To switch back to the ``developer`` user run:

``oc login --username developer``{{execute}}

Because you had already provided a password for the ``developer`` user, you will not be prompted to supply it again. The only time you would be prompted again to provide the password, or supply a new session token, when switching users, is if the active session had expired.

You can validate that you are now the ``developer`` user by running:

``oc whoami``{{execute}}

If you are working against multiple OpenShift clusters, to switch between them, you again use ``oc login``, but supply just the URL for the OpenShift cluster. For example, if you had an account with the OpenShift Online free starter tier, and had been assigned to the ``us-east-1`` cluster, you could run:

``oc login https://api.starter-us-east-1.openshift.com``

When switching which OpenShift cluster is used, if you do not explicitly say which user to use, it will use whatever was the last user you were logged in as with that cluster. You can still provide ``--username`` if required.

Switching, without needing to supply the password or register with a token is possible as details for each are saved away separately in what is called a context. You can see what the current context is by running:

``oc whoami --show-context``{{execute}}

You can get a list of all OpenShift clusters you have ever logged into by running:

``oc config get-clusters``{{execute}}

You can get a list of all contexts which have ever been created, indicating what users on those clusters you have logged in as, and which projects you have worked on, by running:

``oc config get-contexts``{{execute}}
