## Generate Load

With our app deployed to OpenShift, let's setup a loop that will test random numbers for primeness. Click the following command to endlessly run `curl` every 2 seconds with a random prime number:

`while [ true ] ; do
        BITS=$(( ( RANDOM % 60 )  + 1 ))
        NUM=$(openssl prime -generate -bits $BITS)
        curl http://primes-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/prime/${NUM}
        sleep 2
done`{{execute}}

With that running, click on this link to [open up the Prometheus dashboard](http://prometheus-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/). You'll see the Prometheus UI:

![Prometheus UI](/openshift/assets/middleware/quarkus/prom.png)

Within about 15-30 seconds, Prometheus should start scraping the metrics. Start typing in the query box to look for `acme`:

> **Note**
>
> If you do not see any `acme` metrics when querying, wait 15 seconds, reload the Prometheus page, and try again. They
> will eventually show up\!

![Prometheus UI](/openshift/assets/middleware/quarkus/promnames.png)

Type `performedChecks` in the query, and select `application_org_acme_quickstart_PrimeNumberChecker_performedChecks_total` in the box, and click **Execute**. This will
fetch the values from our metric showing the number of checks performed:

![Prometheus UI](/openshift/assets/middleware/quarkus/promchecks.png)

Click the **Graph** tab to see it visually, and adjust the time period to `5m`:

![Prometheus UI](/openshift/assets/middleware/quarkus/promgraph.png)

Cool\! You can try this with some of the JVM metrics as well, e.g. try to graph the `base_memory_usedHeap_bytes` to
see how much heap memory our app is using over time:

![Prometheus UI](/openshift/assets/middleware/quarkus/prommem.png)

Of course Quarkus apps use very little memory, even for apps stuffed with all sorts of extensions and code. You can also see where the garbage collector is doing its thing (the drop in the graph).

Keep the `curl` loop running and we'll move on to build a full dashboard for our app in the next step.