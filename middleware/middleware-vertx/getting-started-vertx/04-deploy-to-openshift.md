# Deploy to OpenShift

Running the application on your local computer is great for a quick turn around, but it's also good to test the application in a production like environment. 


NOTE: **Openshift** also provides great CI/CD and pipeline functionality, but that is out of scope for the *Getting started scenarios*.



**1. Deploying the application to your private project**

Red Hat OpenShift Application Runtimes includes a powerful maven plugin that can take an existing Vert.x application and generate necessary Kubernetes configuration. 

To deploy our application (and route) just execute the following

``mvn fabric8:deploy -Popenshift``{{execute}}

**2. Verify**

After the maven build as finished, it will typically take less than 20 sec for the application to be available. To verify that everything is started run the following command and wait for it to report `replication controller "http-vertx-1" successfully rolled out`:

``oc rollout status dc/http-vertx``{{execute}}

Then either go to the openshift web console and click on the route or click [here](http://http-vertx-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com)

Test and verify that the Invoke button works.

## Congratulations

You have now successfully deploy your application to the OpenShift Container Platform. 

Now you've learned how to take an existing application and deploy it to OpenShift/Kubernetes. 
