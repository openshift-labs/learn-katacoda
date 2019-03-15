# Add health check
One limitation of our current application is that we do not provide an away for OpenShift to correctly monitoring it. Optimally we should probably add a specific health check route so please check out the [health check mission](https://access.redhat.com/documentation/en-us/red_hat_openshift_application_runtimes/1/html/eclipse_vert.x_runtime_guide/missions-intro#mission-health-check-vertx) , but for the moment we will add a simple call to '/', just to check that the Vert.x instance is alive and responding.

## Health check warning

Open the [OpenShift webconsole Deployment config page](https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/dev/browse/dc/http-vertx?tab=configuration)

You will then see the following warning

![Health Check Warning](/openshift/assets/middleware/rhoar-getting-started-vertx/health-check-warning.png)

This is just a warning, and your container might be working 100% correctly, but without a proper health-check configured there is no way for OpenShift to tell if the application is responding correctly or not.  

# Monitor if applications are responding correctly

**1. Add a health check**

Open the `pom.xml`{{open}} file and add the following lines at the `<!-- ADD HEALTH CHECK HERE -->` comment.

<pre class="file" data-filename="pom.xml" data-target="insert" data-marker="<!-- ADD HEALTH CHECK HERE -->">
  &lt;config&gt;
    &lt;vertx-health-check&gt;
      &lt;path&gt;/&lt;/path&gt;
    &lt;/vertx-health-check&gt;
  &lt;/config&gt;
</pre>

After making this change, the fabric8:plugin has enough details to create the health-checks for us, and we can now redeploy our application with health checks active

**2. Re-deploy the application**

Redeploy the application by running the fabric8:deploy goal again.

``mvn fabric8:undeploy fabric8:deploy -Popenshift``{{execute}}

Wait for the rollout to finish.

``oc rollout status dc/http-vertx``{{execute}}

Check that the warning is now gone from the [OpenShift webconsole Deployment config page](https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com/console/project/dev/browse/dc/http-vertx?tab=configuration)

**3. Test**

Below is a rather complex command that does several steps in one. After the command, the different steps are explained in more detail.

``oc --server https://$(hostname):8443 --insecure-skip-tls-verify=true rsh $(oc get pods -l app=http-vertx -o name) pkill java && oc get pods -w``{{execute}}

`oc get pods -l app=http-vertx -o name` will return the name of the running pod, which is different each time.

`oc rsh <pod> pkill java` stops the application.

`oc get pods -w` will watch the pods over time and report any status changes to the pods, e.g., if they have crashed and needs to be restarted, etc.

Type **CTRL+c** after a new pod is up and running to stop the watching the status of the pods.

Now verify that the application has recovered and is responding again [here](http://http-vertx-dev.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com).
