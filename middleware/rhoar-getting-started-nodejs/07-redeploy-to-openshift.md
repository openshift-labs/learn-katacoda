With our code and ConfigMap in place, lets rebuild and redeploy using the same command as before. Execute the command:

```npm run openshift```{{execute}}

The rebuild and redeploy may take a minute or two. Wait for it to complete.

After the build finishes it will take less than a minute for the application to become available.
To verify that everything is started, run the following command again

``oc rollout status dc/nodejs-configmap``{{execute}}

and wait for it to report
`replication controller "nodejs-configmap-2" successfully rolled out`

Once the application is re-deployed, re-visit the sample UI by clicking the
[application link](http://nodejs-configmap-example.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com)

> You can also access the application through the link on the OpenShift Web Console Overview page. ![Overview link](/openshift/assets/middleware/rhoar-getting-started-nodejs/overview-link.png)

The application will now read the ConfigMap values and use them in place of the hard-coded default.

**Test the updated app**

Enter a name in the 'Name' field and click **Invoke** to test out the service. You should
now see the updated message `Hello, [name] from a ConfigMap !` indicating that the application
successfully accessed the ConfigMap and used its value for the message.

![New message](/openshift/assets/middleware/rhoar-getting-started-nodejs/new-message.png)

In the final step, we'll modify the ConfigMap and verify that the application successfully
picks up the changes automatically.
