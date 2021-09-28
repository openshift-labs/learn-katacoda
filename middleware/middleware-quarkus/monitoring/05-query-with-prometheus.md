## Generate Load

We will use the open source [OpenSSL](https://www.openssl.org/) project to generate some test primes to exercise our app. Click the following command to verify openssl is installed. If it is not, you may need to wait a few seconds and click the command again until it reports a proper version

`openssl version`{{execute T1}}

Then you should see

```console
OpenSSL 1.1.1g FIPS  21 Apr 2020
```

With our app deployed to OpenShift, let's setup a loop that will test random numbers for primeness. Click the following command to endlessly run `curl` every 2 seconds with a random prime number:

`while [ true ] ; do
        BITS=$(( ( RANDOM % 60 )  + 1 ))
        NUM=$(openssl prime -generate -bits $BITS)
        curl http://primes-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/is-prime/${NUM}
        sleep 2
done`{{execute T1}}

With that running, click on this link to [open up the Prometheus dashboard](http://prometheus-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/). You'll see the Prometheus UI:

![Prometheus UI](/openshift/assets/middleware/quarkus/prom.png)

Within about 15-30 seconds, Prometheus should start scraping the metrics. Start typing in the query box to look for `prime`:

> **Note**
>
> If you do not see any `prime` metrics when querying, wait 15 seconds, reload the Prometheus page, and try again. They
> will eventually show up\!

![Prometheus UI](/openshift/assets/middleware/quarkus/promnames.png)

Type `prime` in the query, and select `prime_number_max` in the box, and click **Execute**. This will
fetch the values from our metric showing the largest prime number found so far:

![Prometheus UI](/openshift/assets/middleware/quarkus/promchecks.png)

Cool\! You can try this with some of the standard HTTP metrics as well, e.g. try to graph the `http_server_requests_seconds_count` to
see how often our various HTTP endpoints are accessed. You can see the endpoints shown with different colors, one for each endpoint (`/is-prime/{number}`, `/q/metrics`, and the 404 not-found endpoint).

![Prometheus UI](/openshift/assets/middleware/quarkus/promgraph.png)


Keep the `curl` loop running and we'll move on to build a full dashboard for our app in the next step.