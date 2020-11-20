With the project space now available, let's create the broker instance.

### Inspect the ActiveMQArtermis custom resource

Click the link below to open the custom resource (CR) definition for the cluster:

* `amq-broker.yaml`{{open}}

As you can see, we are enabling just one single acceptor and configuring it to accept incomming `AMQP` connections in the default `5672` port.

We are also enabling the _console_ and exposing the endpoints for external access too.

### Creating an AMQ broker

Switch to the application directory in the command line by issuing the following command:

```cd /root/projects/amq-examples/amq-js-demo```{{execute interrupt}}

Create a new broker using the OpenShift command:

``oc -n messaging apply -f amq-broker.yaml``{{execute}}

This command will create a broker customer resource, the operator then will take notice of the desired state and will create the required deployment and resources missing to run a new instance.

You should see the output:

```bash
activemqartemis.broker.amq.io/broker created
```

### Check broker deployment

Follow up the AMQ broker deployment to validate it is running.

To watch the pods status run the following command:

``oc -n messaging get pods -w``{{execute}}

You will see the pod for the broker StatefulSet changing the status to `running`. It should look similar to the following:

```bash
NAME                                  READY   STATUS              RESTARTS   AGE
amq-broker-operator-6c76986f9-brl67   1/1     Running             0          15m
broker-ss-0                           0/1     ContainerCreating   0          5s
broker-ss-0                           0/1     ContainerCreating   0          6s
broker-ss-0                           0/1     Running             0          25s
broker-ss-0                           1/1     Running             0          57s
```

Hit <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the process.

`^C`{{execute ctrl-seq}}

When the provisioning of the broker finishes, you will be set to start using the service. In the next step you will deploy a simple messging application.
