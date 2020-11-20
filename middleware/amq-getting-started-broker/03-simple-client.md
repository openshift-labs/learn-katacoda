The sample project in the upper right part side of the screen, shows the components of your sample Node.js project. This project uses [Red Hat Runtimes](https://developers.redhat.com/appruntimes), a set of open source cloud native application runtimes for modern applications.

The app implements a simple messaging greeting service that simply sends a Hello World! to a queue and the same application listens in the same queue for greeting messages. We use the Red Hat AMQ JavaScript Client to create a connection to the messaging broker to send and receive messages.

> The AMQ Clients is a suite of AMQP 1.0 messaging APIs that allow you to make any application a messaging application. It includes both industry-standard APIs such as JMS and new event-driven APIs that make it easy to integrate messaging anywhere. The AMQ Javascript Client is based on the [AMQP Rhea Project](https://github.com/amqp/rhea).

### Inspect the application code

Click the links below to open each file and inspect its contents:

* `package.json`{{open}} - Metadata about the project: name, version, dependencies, and other information needed to build and maintain the project.
* `app.js`{{open}} - Main logic of the sample application.

### Install Dependencies

Dependencies are listed in the `package.json` file and declare which external projects this sample app requires.
To download and install them, run the following command:

``npm install``{{execute interrupt}}

It will take a few seconds to download, and you should see a final report such as 

```bash
added 140 packages in 2.937s
```

### Deploy

Build and deploy the project using the following command:

```npm run openshift```{{execute}}

> This uses NPM and the [Nodeshift](https://github.com/bucharest-gold/nodeshift) project to build and deploy the sample application to OpenShift using the containerized Node.js runtime.

The build and deploy may take a minute or two. Wait for it to complete.

You should see `INFO complete` at the end of the build output, and you should not see any obvious errors or failures.

### Check application deployment

Follow up the application deployment to validate it is running.

To watch the pods status run the following command:

``oc -n messaging get pods -w``{{execute}}

You will see the pod for the application changing the status to `running`. It should look similar to the following:

```bash
NAME                                  READY   STATUS      RESTARTS   AGE
amq-broker-operator-6c76986f9-6vjhj   1/1     Running     0          6m5s
amq-js-demo-1-deploy                  0/1     Completed   0          32s
amq-js-demo-1-dftm4                   1/1     Running     0          26s
amq-js-demo-s2i-1-build               0/1     Completed   0          90s
broker-ss-0                           1/1     Running     0          4m46s
```

Hit <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the process.

`^C`{{execute ctrl-seq}}

In the next step you will check your application is running.
