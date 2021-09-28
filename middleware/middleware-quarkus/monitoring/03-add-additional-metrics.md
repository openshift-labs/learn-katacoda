# Add additional metrics

Out of the box, you get a lot of basic JVM metrics which are useful, but what if you wanted to provide metrics for your
app? Let’s add a few using the Quarkus metrics APIs.

Click here to open a new file `./primes/src/main/java/org/acme/quickstart/PrimeNumberResource.java`{{open}}.

This new class will implement an algorithm for checking whether a number is a prime number. This algorithm is exposed over a REST interface. With the Micrometer extension enabled, metrics for all http server requests are also collected automatically.

We do want to add a few other metrics to demonstrate how to add and filter metrics:

* A counter will be incremented for every prime number discovered
* A gauge will store the highest prime number discovered
* A timer will record the time spent testing if a number is prime.

Click **Copy To Editor** to create the code for our new class:

<pre class="file" data-filename="./primes/src/main/java/org/acme/quickstart/PrimeNumberResource.java" data-target="replace">
package org.acme.quickstart;

import io.micrometer.core.instrument.MeterRegistry;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.util.concurrent.atomic.LongAccumulator;
import java.util.function.Supplier;

@Path(&quot;/is-prime&quot;)
public class PrimeNumberResource {

    private final LongAccumulator highestPrime = new LongAccumulator(Long::max, 0);
    private final MeterRegistry registry;

    PrimeNumberResource(MeterRegistry registry) {
        this.registry = registry;

        // Create a gauge that uses the highestPrimeNumberSoFar method
        // to obtain the highest observed prime number
        registry.gauge(&quot;prime.number.max&quot;, this,
                PrimeNumberResource::highestObservedPrimeNumber);
    }

    @GET
    @Path(&quot;/{number}&quot;)
    @Produces(MediaType.TEXT_PLAIN)
    public String checkIfPrime(@PathParam(&quot;number&quot;) long number) {
        if (number &lt; 1) {
            return &quot;Only natural numbers can be prime numbers.&quot;;
        }
        if (number == 1) {
            return &quot;1 is not prime.&quot;;
        }
        if (number == 2) {
            return &quot;2 is prime.&quot;;
        }
        if (number % 2 == 0) {
            return number + &quot; is not prime, it is divisible by 2.&quot;;
        }

        Supplier&lt;String&gt; supplier = () -&gt; {
            for (int i = 3; i &lt; Math.floor(Math.sqrt(number)) + 1; i = i + 2) {
                if (number % i == 0) {
                    return number + &quot; is not prime, is divisible by &quot; + i + &quot;.&quot;;
                }
            }
            highestPrime.accumulate(number);
            return number + &quot; is prime.&quot;;
        };

        return registry.timer(&quot;prime.number.test&quot;).wrap(supplier).get();
    }

    /**
     * This method is called by the registered {@code highest.prime.number} gauge.
     * @return the highest observed prime value
     */
    long highestObservedPrimeNumber() {
        return highestPrime.get();
    }
}
</pre>

Let's test it out by accessing the new endpoint with a few prime and non-prime numbers:

Click the following commands to test whether the number is a prime number:

`curl http://localhost:8080/is-prime/1`{{execute T2}}

You should see `1 is not prime.`.

`curl http://localhost:8080/is-prime/350`{{execute T2}}

You should see `350 is not prime, it is divisible by 2.`.

`curl http://localhost:8080/is-prime/629521085409773`{{execute T2}}

You should see `629521085409773 is prime.`.

`curl http://localhost:8080/is-prime/1111111111111111111`{{execute T2}}

You should see `1111111111111111111 is prime.`.

Each command will output whether the number is prime or not. The last two commands will take considerably longer (up to 5-10 seconds) as these are large prime numbers (that also form [the basis](https://access.redhat.com/blogs/766093/posts/2177481) of modern internet security!).

Review the metrics generated so far to see them in action:

`curl http://localhost:8080/q/metrics`{{execute T2}}

You'll see many metrics, for example:

```
# HELP prime_number_max
# TYPE prime_number_max gauge
prime_number_max 887.0
# TYPE http_server_requests_seconds summary
http_server_requests_seconds_count{method="GET",outcome="SUCCESS",status="200",uri="/is-prime/{number}",} 4.0
http_server_requests_seconds_sum{method="GET",outcome="SUCCESS",status="200",uri="/is-prime/{number}",} 0.082716484
```

You can also display only our "prime"-related metrics:

`curl -s http://localhost:8080/q/metrics | grep -i prime`{{execute T2}}

> **NOTE**: Metrics are generated lazily, so you often won’t see any data for your endpoint until something tries to access it!

> **NOTE**: You can optionally enable the [JSON exporter](https://quarkus.io/guides/micrometer#quarkus-micrometer_quarkus.micrometer.export.json.enabled) to output metrics as JSON-formatted objects. One enabled, requests must pass the `Accept: application/json` HTTP header to get JSON metrics.

## Configuring and Filtering Metrics

Micrometer uses `MeterFilter` instances to customize the metrics emitted by `MeterRegistry` instances. The Micrometer extension will detect `MeterFilter` CDI beans and use them when initializing `MeterRegistry` instances. These can be used to exercise greater control over how and when meters are registered and what kinds of statistics they emit. Meter filters serve three basic functions:

* **Deny** (or accept) meters from being registered.
* **Transform** meter IDs (e.g. changing the name, adding or removing tags, changing description or base units).
* **Configure** distribution statistics for some meter types (e.g. timers)

To create MeterFilters, you can simply declare them using annotations in your code. Quarkus will identify and inject them into `MeterRegistry`s as they are created, based on criteria specified in the annotations.

Click here to open a new file `primes/src/main/java/org/acme/quickstart/CustomConfiguration.java`{{open}}.

Click **Copy To Editor** to create the code for our new class:

<pre class="file" data-filename="./primes/src/main/java/org/acme/quickstart/CustomConfiguration.java" data-target="replace">
package org.acme.quickstart;

import java.util.Arrays;

import javax.annotation.Priority;
import javax.inject.Singleton;
import javax.interceptor.Interceptor;
import javax.enterprise.inject.Produces;

import org.eclipse.microprofile.config.inject.ConfigProperty;

import io.micrometer.core.instrument.Clock;
import io.micrometer.core.instrument.Meter;
import io.micrometer.core.instrument.Tag;
import io.micrometer.core.instrument.config.MeterFilter;
import io.micrometer.core.instrument.distribution.DistributionStatisticConfig;
import io.micrometer.prometheus.PrometheusConfig;
import io.micrometer.prometheus.PrometheusMeterRegistry;
import io.prometheus.client.CollectorRegistry;
import io.quarkus.micrometer.runtime.MeterFilterConstraint;

@Singleton
public class CustomConfiguration {

    @ConfigProperty(name = &quot;deployment.env&quot;)
    String deploymentEnv;

    @Produces
    @Singleton
    @MeterFilterConstraint(applyTo = PrometheusMeterRegistry.class)
    public MeterFilter configurePrometheusRegistries() {
        return MeterFilter.commonTags(Arrays.asList(
                Tag.of(&quot;registry&quot;, &quot;prometheus&quot;)));
    }

    @Produces
    @Singleton
    public MeterFilter configureAllRegistries() {
        return MeterFilter.commonTags(Arrays.asList(
                Tag.of(&quot;env&quot;, deploymentEnv)));
    }

    /** Enable histogram buckets for a specific timer */
    @Produces
    @Singleton
    public MeterFilter enableHistogram() {
        return new MeterFilter() {
            @Override
            public DistributionStatisticConfig configure(Meter.Id id, DistributionStatisticConfig config) {
                if(id.getName().startsWith(&quot;prime&quot;)) {
                    return DistributionStatisticConfig.builder()
                        .percentiles(0.5, 0.95)     // median and 95th percentile, not aggregable
                        .percentilesHistogram(true) // histogram buckets (e.g. prometheus histogram_quantile)
                        .build()
                        .merge(config);
                }
                return config;
            }
        };
    }
}
</pre>

These do the following:

* **`configurePrometheusRegistries`** - Adds custom tag of `registry: prometheus` to Prometheus registry metrics
* **`configureAllRegistries`** Adds a custom tag of `env: [value]` using the value of the `ConfigProperty` named `deploymentEnv` (which must be present in your `application.properties`)
* **`enableHistogram`** - This enables any timer metric whose name begins with `prime` to report additional quantile metrics (mean, median, and other custom histograms)

Filtering and tagging can be useful to organize the reporting, so you can more easily draw conclusions about data.

Finally, you need to add the configuration value referenced in the `configureAllRegistries` filter to your `application.properties`.

Click here to open the file (it will be empty): `primes/src/main/resources/application.properties`{{open}}.

Then click **Copy to Editor** to add the following values to the `application.properties` file:

<pre class="file" data-filename="./src/main/resources/application.properties" data-target="replace">
# Configure value for the tag we add to metrics
deployment.env=prod

</pre>

This will cause a tag `env: prod` to be added to each metric based on our above filter.

## Test new metrics

Let's do a quick test and make sure they're working. Access the endpoint a couple more times by clicking on the below commands:

`curl http://localhost:8080/is-prime/350`{{execute T2}}

`curl http://localhost:8080/is-prime/629521085409773`{{execute T2}}

Now let's see if it worked. Let's look for our `prime` metrics with this command:

`curl -s http://localhost:8080/q/metrics | grep prime`{{execute T2}}

You should see new types of quantile metrics along with our new `env` and `registry` tags:

```console
prime_number_test_seconds{env="prod",registry="prometheus",quantile="0.5",} 0.0
prime_number_test_seconds{env="prod",registry="prometheus",quantile="0.95",} 0.0
prime_number_test_seconds_bucket{env="prod",registry="prometheus",le="0.001",} 0.0
prime_number_test_seconds_bucket{env="prod",registry="prometheus",le="0.001048576",} 0.0
prime_number_test_seconds_bucket{env="prod",registry="prometheus",le="0.001398101",} 0.0
prime_number_test_seconds_bucket{env="prod",registry="prometheus",le="0.001747626",} 0.0
...
```

It's not that fun to read the raw output, it'd be better if we had a better way to manage the monitoring of these metrics. Let's do that with Prometheus and OpenShift!

## Cleanup

We're done coding, so let's stop the app. In the first Terminal, press `CTRL-C` to stop the running Quarkus app (or click the `clear`{{execute T1 interrupt}} command to do it for you).

