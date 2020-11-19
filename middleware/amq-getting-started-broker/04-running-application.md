After the previous step build finishes, it will take less than a minute for the application to become available.

### Check the application logs

Now that the application is up and running you can check the logs to check how is everything going on.

Let's use the OpenShift CLI tool to connect with the deployment and view the pod's log.

Use the following command to retrieve the logs:

`oc -n messaging logs dc/amq-js-demo`{{execute interrupt}}

You will see a message every 10 seconds with the following text:

``Message received: Hello World!``

This message is been sent and received to the ``example`` queue by the application you just deployed.
