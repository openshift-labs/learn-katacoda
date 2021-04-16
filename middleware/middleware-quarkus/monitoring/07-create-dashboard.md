# Create Dashboard

In the Grafana Dashboard, hover over the `+` button on the left, and select *Create \> Dashboard*:

![Grafana UI](/openshift/assets/middleware/quarkus/grafcreate.png)

Next, click **Add an Empty Panel**.

This will create a new dashboard with a single Panel. Each Panel can visualize a computed metric (either a single
metric, or a more complex query) and display the results in the Panel.

In the _Metrics_ box, type `prime` to again get an autocompleted list of available metrics that match that name:

![Grafana UI](/openshift/assets/middleware/quarkus/grafquery.png)

Choose from the drop-down `prime_number_test_seconds_max`. Then click on the **Refresh** button to begin to show in the graph above:

![Grafana UI](/openshift/assets/middleware/quarkus/grafgraf.png)

This is querying the custom `prime.number.test` metric from our earlier Java code we created. With the `seconds_max` suffix it will show the max # of seconds taken to calculate a prime from our `curl` loop still running.

> **Note**: Statistics like max, percentiles, and histogram counts decay over time to give greater weight to recent samples, so you'll see even the `max` value going up and down as older values drop out of the rolling window of samples.

Next click on the *Visualization* section on the right:

![Grafana UI](/openshift/assets/middleware/quarkus/grafvis.png)

This lets you fine tune the display, along with the type of graph (bar, line, gauge, etc). Leave them for now, and look up in the _Settings_ section above, and change the name of the panel to `Prime Time`.

![Grafana UI](/openshift/assets/middleware/quarkus/graftitle.png)

There is an *Alerts* tab you can configure to send alerts (email, etc) when conditions are met for this and other
queries. We’ll skip this for now.

Click *Save* at the top right to save our new dashboard and give it a name such as _My Prime Dashboard_.

![Grafana UI](/openshift/assets/middleware/quarkus/grafsave.png)

# Add more Panels

See if you can add additional Panels. Use the **Add Panel** button to add a new Panel:

![Grafana UI](/openshift/assets/middleware/quarkus/grafmorepanels.png)

Follow the same steps as before to create a few more panels, and **don’t forget to Save each panel when you’ve created
it.**

Add Panels for:

  - The HTTP endpoint timers `http_server_requests_seconds_count` (name it "Primes HTTP Timer" on the *General* tab).
  - The RSS Memory used by the app `process_resident_memory_bytes` (set the title to `RSS Memory` on the *General* tab.

To see the quantile metrics, create another panel for the `prime_number_test_seconds_bucket` metric. When you select that metric in Grafana, it will notice you'll want a histogram panel, so click the helpful tip to show the 95% quantile:

![Grafana UI](/openshift/assets/middleware/quarkus/grafhist.png)

The graph will update to show the 95% quantile of the time it takes to evaluate whether a number is prime or not:

![Grafana UI](/openshift/assets/middleware/quarkus/grafhistdata.png)

# Fix layout

After saving, go back to the main dashboard (click on **Quar** at the top and then select it under *Recent
Dashboards*). Change the time value to *Last 15 Minutes* at the top-right:

![time](/openshift/assets/middleware/quarkus/graftime.png)

Finally, drag and resize the different panels to look nice and fit on a single page.

Click **Save Dashboad** again to save it. Your final Dashboard should look like:

![final](/openshift/assets/middleware/quarkus/graffinal.png)

You can add many more metrics to monitor and alert for Quarkus apps using these tools.

# Congratulations\!

This exercise demonstrates how your Quarkus application can utilize the [Micrometer
Metrics extension](https://quarkus.io/guides/micrometer) to visualize metrics for Quarkus applications. You also
consumed these metrics using a popular monitoring stack with Prometheus and Grafana and other APM tools that support Micrometer.

There are many more possibilities for application metrics, and it’s a useful way to not only gather metrics, but act on
them through alerting and other features of the monitoring stack you may be using.
