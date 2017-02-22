In this course you learnt about how to log into an OpenShift cluster, as well as how you can add other users as collaborators to you project.

You can find a summary of the key commands covered below, along with some related commands. To see more information on each ``oc`` command, run it with the ``--help`` option.

``oc login``: Log in to your OpenShift cluster and save the session token for subsequent use. You will be prompted for the user name and password or directed to a web console page where you can obtain a token you must then use to use to login from the command line. The web page will require you to first login in to the web console if you are not already logged in.

``oc login <server>``:
    Log in to a specific OpenShift cluster. You will need to specify the name of the server as argument the first time you are using it, or if switching back to it after having used a different cluster.

``oc login --username <user>``:
    Log in to your OpenShift cluster as a specific user.

``oc login --username <username> --password <password>``:
    Log in to your OpenShift cluster as a specific user and supply the password on the command line. Note that this is not recommended for real systems as your password may be logged or retained in command history.

``oc login --token <token>``:
    Log in to your server using a token for an existing session.

``oc logout``:
    Log out of the active session by clearing the session token.

``oc whoami``:
    Show the name of the user for the current login session.

``oc whoami --token``:
    Show the token for the current login session.

``oc whoami --show-server``:
    Show which OpenShift cluster you are logged into.

``oc whoami --show-context``:
    Shows the context for the current session. This will include details about the project, server and name of user, in that order.

``oc config get-clusters``:
    Show a list of all OpenShift clusters ever logged in to.

``oc config get-contexts``:
    Show a list of contexts for all sessions ever created. For each context listed, this will include details about the project, server and name of user, in that order.

``oc adm policy add-role-to-user edit <username> -n <project>``: Add another user to a project so that they can work within the project, including creating new deployments or deleting applications.

``oc adm policy add-role-to-user view <username> -n <project>``: Add another user to a project but such that they can only view what is in the project.

``oc adm policy add-role-to-user admin <username> -n <project>``: Add another user to a project such that they are effecively a joint owner of the project and have administration rights over it, including the ability to delete the project.
