By default, OpenShift does not verify passwords. Once the user has been set up the user can be added to projects. 

## Task

The command below creates a user called _developer_ and adds it to the green-hat-store project.

`oc create user developer && oc policy add-role-to-user admin developer -n green-hat-store`{{execute}}

After this, you can log in and view the builds in the Console UI. Access it via the URL below, it can take a few moments for OpenShift to apply the permissions. Remember, the password can be anything but the username has to be _developer_.

https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/green-hat-store/browse/builds/frontend
