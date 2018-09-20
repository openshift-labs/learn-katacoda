With the project space now available, let's create the broker instance.

To allow ingress traffic to the messaging destinations, configure the required secrets with the following command:

``oc create sa amq-service-account``{{execute}}

Add cluster capabilities to service account

``oc policy add-role-to-user view system:serviceaccount:messaging:amq-service-account``{{execute}}

Create a new app using the OpenShift command:

``oc new-app amq-broker-71-basic -p AMQ_PROTOCOL=openwire,amqp,stomp,mqtt -p AMQ_USER=amquser -p AMQ_PASSWORD=amqpassword -p AMQ_QUEUES=example``{{execute}}

This command will create a broker instance with the ``OpenWire`` and ``AMQP`` protocols enabled. At the same time, will create a queue named ``example``.

You should see the output:

```
--> Deploying template "openshift/amq-broker-71-basic" to project messaging

     JBoss AMQ Broker 7.1 (Ephemeral, no SSL)
     ---------
     Application template for JBoss AMQ brokers. These can be deployed as standalone or in a mesh. This template doesn't feature SSL support.

     A new messaging service has been created in your project. It will handle the protocol(s) "openwire,amqp,stomp,mqtt". The username/password for accessing the service is amquser/amqpassword.

     * With parameters:
        * Application Name=broker
        * AMQ Protocols=openwire,amqp,stomp,mqtt
        * Queues=example
        * Topics=
        * AMQ Username=amquser
        * AMQ Password=amqpassword
        * AMQ Role=admin
        * AMQ Name=broker
        * AMQ Global Max Size=100 gb
        * ImageStream Namespace=openshift

--> Creating resources ...
    route "console" created
    service "broker-amq-jolokia" created
    service "broker-amq-amqp" created
    service "broker-amq-mqtt" created
    service "broker-amq-stomp" created
    service "broker-amq-tcp" created
    deploymentconfig "broker-amq" created
--> Success
    Access your application via route 'console-messaging.2886795275-80-kitek02.environments.katacoda.com'
    Run 'oc status' to view your app.
```

When the provisioning of the broker finishes, you will be set to start using the service. In the next step you will deploy a simple messging application.
