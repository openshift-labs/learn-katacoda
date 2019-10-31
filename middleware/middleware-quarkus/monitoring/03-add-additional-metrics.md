# Add additional metrics

Out of the box, you get a lot of basic JVM metrics which are useful, but what if you wanted to provide metrics for your
app? Let’s add a few using the MicroProfile Metrics APIs.

Click here to open the `getting-started/src/main/java/org/acme/quickstart/GreetingResource.java`{{open}}.

Let’s add a metric to count the number of times we’ve greeted someone. Click **Copy to Editor** to add the following annotation to the `hello()` method:

<pre class="file" data-filename="./getting-started/src/main/java/org/acme/quickstart/GreetingResource.java" data-target="insert" data-marker="@GET">
@Counted(name = "greetings", description = "How many greetings we've given.")
    @GET
</pre>

You'll need to import the new `Counted` class, so click **Copy To Editor** to add it:

<pre class="file" data-filename="./getting-started/src/main/java/org/acme/quickstart/GreetingResource.java" data-target="insert" data-marker="import javax.ws.rs.GET;">
import org.eclipse.microprofile.metrics.annotation.Counted;
import javax.ws.rs.GET;
</pre>

Quarkus will automatically rebuild the app after these changes. Now, trigger a greeting:

`curl http://localhost:8080/hello`{{execute T2}}

And then access the metrics again, this time we’ll look for our new metric, specifying a scope of *application* in the
URL so that only metrics in that *scope* are returned:

`curl http://localhost:8080/metrics/application`{{execute T2}}

You’ll see:

``` none
# HELP application_org_acme_quickstart_GreetingResource_greetings_total How many greetings we've given.
# TYPE application_org_acme_quickstart_GreetingResource_greetings_total counter
application_org_acme_quickstart_GreetingResource_greetings_total 1.0
```

This shows we’ve accessed the greetings once (`1.0`). Repeat the `curl` greeting a few times and then access metrics
again, and you’ll see the number rise.

> **Note**
>
> The comments in the metrics output starting with `#` are part of the format and give human-readable descriptions to
> the metrics which you’ll see later on.

> **Note**
>
> In the OpenMicroProfile Metrics names are prefixed with things like `vendor:` or `application:` or `base:`. These *scopes* can be selectively accessed by adding the name to the accessed endpoint, e.g. `curl http://localhost:8080/metrics/application` or `curl http://localhost:8080/metrics/base`.

# Add a few more

Let’s add another class with some different types of metrics. This new class implements an algorithm for checking whether a number is a prime number. This algorithm is exposed over a REST interface. Additionally, we need a few annotations to make sure that our desired metrics are calculated over time and can be exported for manual analysis or processing by additional tooling.

Click here to create a new class: `getting-started/src/main/java/org/acme/quickstart/PrimeNumberChecker.java`{{open}}.

Then click **Copy To Editor** to create the code with metrics:

<pre class="file" data-filename="./getting-started/src/main/java/org/acme/quickstart/PrimeNumberChecker.java" data-target="replace">
package org.acme.quickstart;

import org.eclipse.microprofile.metrics.MetricUnits;
import org.eclipse.microprofile.metrics.annotation.Counted;
import org.eclipse.microprofile.metrics.annotation.Gauge;
import org.eclipse.microprofile.metrics.annotation.Timed;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;

@Path("/prime")
public class PrimeNumberChecker {

    private long highestPrimeNumberSoFar = 2;

    @GET
    @Path("/{number}")
    @Produces("text/plain")
    @Counted(name = "performedChecks", description = "How many primality checks have been performed.")
    @Timed(name = "checksTimer", description = "A measure of how long it takes to perform the primality test.", unit = MetricUnits.MILLISECONDS)
    public String checkIfPrime(@PathParam("number") long number) {
        if (number < 1) {
            return "Only natural numbers can be prime numbers.";
        }
        if (number == 1) {
            return "1 is not prime.";
        }
        if (number == 2) {
                    return "2 is prime.";
        }
        if (number % 2 == 0) {
            return number + " is not prime, it is divisible by 2.";
        }
        for (int i = 3; i < Math.floor(Math.sqrt(number)) + 1; i = i + 2) {
            if (number % i == 0) {
                return number + " is not prime, is divisible by " + i + ".";
            }
        }
        if (number > highestPrimeNumberSoFar) {
            highestPrimeNumberSoFar = number;
        }
        return number + " is prime.";
    }

    @Gauge(name = "highestPrimeNumberSoFar", unit = MetricUnits.NONE, description = "Highest prime number so far.")
    public Long highestPrimeNumberSoFar() {
        return highestPrimeNumberSoFar;
    }

}
</pre>

The metrics that this app will gather are these:

* **`performedChecks`**: A counter which is increased by one each time the user asks about a number.
* **`highestPrimeNumberSoFar`**: This is a _gauge_ that stores the highest number that was asked about by the user and which was determined to be prime.
* **`checksTimer`**: This is a timer (a compound metric that generates many different quantile metrics) that benchmarks how much time the primality tests take. All _durations_ are measured in _milliseconds_. It will generate several sub-metrics related to the overall metric:
    * `min`: The shortest duration it took to perform a primality test, probably it was performed for a small number.
    * `max`: The longest duration, probably it was with a large prime number.
    * `mean`: The mean value of the measured durations.
    * `stddev`: The standard deviation.
    * `count`: The number of observations (so it will be the same value as performedChecks).
    * `p50, p75, p95, p99, p999`: Percentiles of the durations. For example the value in `p95` means that 95% of the measurements were faster than this duration.
    * `meanRate, oneMinRate, fiveMinRate, fifteenMinRate`: Mean throughput and one-, five-, and fifteen-minute exponentially-weighted moving average throughput.

Let's test it out by accessing the new endpoint with a few prime and non-prime numbers:

Click the following commands to test whether the number is a prime number:

`curl http://localhost:8080/prime/1`{{execute T2}}

`curl http://localhost:8080/prime/350`{{execute T2}}

`curl http://localhost:8080/prime/629521085409773`{{execute T2}}

`curl http://localhost:8080/prime/1111111111111111111`{{execute T2}}

Each command will output whether the number is prime or not. The last two commands will take considerably longer (up to 5-10 seconds) as these are large prime numbers.

Review the metrics generated so far to see them in action:

`curl http://localhost:8080/metrics/application`{{execute T2}}

You'll see many metrics, for example:

```
# HELP application_org_acme_quickstart_PrimeNumberChecker_highestPrimeNumberSoFar Highest prime number so far.
# TYPE application_org_acme_quickstart_PrimeNumberChecker_highestPrimeNumberSoFar gauge
application_org_acme_quickstart_PrimeNumberChecker_highestPrimeNumberSoFar 1.11111111111111117E18
# TYPE application_org_acme_quickstart_PrimeNumberChecker_checksTimer_rate_per_second gauge
application_org_acme_quickstart_PrimeNumberChecker_checksTimer_rate_per_second 0.014088858534388415
```

While fun to read, it'd be better if we had a better way to manage the monitoring of these metrics. Let's do that with Prometheus and OpenShift!

## Cleanup

We're done coding, so let's stop the app. In the first Terminal, press `CTRL-C` to stop the running Quarkus app (or click the `clear`{{execute T1 interrupt}} command to do it for you).

