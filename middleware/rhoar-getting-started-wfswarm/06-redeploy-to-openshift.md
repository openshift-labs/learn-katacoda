**1. Rebuild and re-deploy**

With our health check in place, lets rebuild and redeploy using the same command as before:

```mvn fabric8:undeploy fabric8:deploy -Popenshift```{{execute}}

You should see a **BUILD SUCCESS** at the end of the build output.

During build and deploy, you'll notice WildFly Swarm adding in health checks for you:

```console
[INFO] F8: wildfly-swarm-health-check: Adding readiness probe on port 8080, path='/health', scheme='HTTP', with initial delay 10 seconds
[INFO] F8: wildfly-swarm-health-check: Adding liveness probe on port 8080, path='/health', scheme='HTTP', with initial delay 180 seconds
```

To verify that everything is started, run the following command and wait for it report
`replication controller "healthcheck-3" successfully rolled out`

``oc rollout status dc/healthcheck``{{execute}}

Once the project is deployed, you should be able to access the health check logic
 at the `/api/service/health` endpoint using a simple _curl_ command. 
 
This is the same API that OpenShift will repeatedly poll to determine application health.

Click here to try it (you may need to try a few times until the project is fully deployed):

``curl http://healthcheck-example.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/api/service/health``{{execute}}

You should see a JSON response like:

```
{"id":"server-state","result":"UP"}
```

**2. Adjust probe timeout**

The various timeout values for the probes can be configured in many ways. Let's tune the _liveness probe_ initial delay so that
we don't have to wait 3 minutes for it to be activated. Use the **oc** command to tune the
probe to wait 20 seconds before starting to poll the probe:

```oc set probe dc/healthcheck --liveness --initial-delay-seconds=20```{{execute}}

In the next step we'll exercise the probe and watch as it fails and OpenShift recovers the application.