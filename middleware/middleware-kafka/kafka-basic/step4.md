## Running integrations as Kubernetes CronJobs

The previous step can be automatically deployed as a Kubernetes CronJob if the delay between executions is changed into a value that can be expressed by a cron tab expression.

For example, you can edit the first endpoint (`timer:java?period=3000`) in *Routing.java* into the following: `timer:java?period=60000` (1 minute between executions).

Now you can run the integration again:

``kamel run camel-basic/Routing.java --property-file camel-basic/routing.properties``{{execute}}

Now you'll see that Camel K has materialized a cron job (it's might take one minute to appear.):

``oc get cronjob``{{execute}}

You'll find a Kubernetes CronJob named "routing".

```
NAME      SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
routing   0/1 * * * ?   False     0        39s             51s
```

The running behavior changes, because now there's no pod always running (beware you should not store data in memory when using the cronJob strategy).

You can see the pods starting and being destroyed by watching the namespace:

``oc get pod -w``{{execute}}

Hit `ctrl+c` on the terminal window.
To see the logs of each integration starting up, you can use the `kamel log` command:

``kamel log routing``{{execute}}

You should see every minute a JVM starting, executing a single operation and terminating.


The CronJob behavior is controlled via a Trait called `cron`. Traits are the main way to configure high level Camel K features, to customize how integrations are rendered.

To disable the cron feature and use the deployment strategy, you can run the integration with:

``kamel run camel-basic/Routing.java --property-file camel-basic/routing.properties -t cron.enabled=false``{{execute}}


This will disable the cron trait and restore the classic behavior (always running pod).

You should see it reflected in the logs (which will be printed every minute by the same JVM):

``kamel log routing``{{execute}}

Hit `ctrl+c` on the terminal window.

## Congratulations

In this scenario you got to play with Camel K. Focusing on the code, and see the power of how Camel K can enhance your experience when working on Kubernetes/OpenShift. There is much more to Camel K than realtime development and  developer joy. Be sure to visit [Camel K](https://camel.apache.org/camel-k/latest/index.html) to learn even more about the architecture and capabilities of this exciting new framework.
