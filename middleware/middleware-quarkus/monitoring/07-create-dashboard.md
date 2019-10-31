# Create Dashboard

In the Grafana Dashboard, hover over the `+` button on the left, and select *Create \> Dashboard*:

![Grafana UI](/openshift/assets/middleware/quarkus/grafcreate.png)

This will create a new dashboard with a single Panel. Each Panel can visualize a computed metric (either a single
metric, or a more complex query) and display the results in the Panel.

Click **Add Query**. In the _Metrics_ box, type `performed` to again get an autocompleted list of available metrics that match that name:

![Grafana UI](/openshift/assets/middleware/quarkus/grafquery.png)

Choose the only one in the list: `application_org_acme_quickstart_PrimeNumberChecker_performedChecks_total`. The metrics should immediately
begin to show in the graph above:

![Grafana UI](/openshift/assets/middleware/quarkus/grafgraf.png)

Next click on the *Visualization* tab on the left:

![Grafana UI](/openshift/assets/middleware/quarkus/grafvis.png)

This lets you fine tune the display, along with the type of graph (bar, line, gauge, etc). Leave them for now, and click
on the *General* tab. Change the name of the panel to `Prime Checks`.

![Grafana UI](/openshift/assets/middleware/quarkus/graftitle.png)

There is an *Alerts* tab you can configure to send alerts (email, etc) when conditions are met for this and other
queries. We’ll skip this for now.

Click the *Save* icon at the top to save our new dashboard (you can enter a change comment if you want):

![Grafana UI](/openshift/assets/middleware/quarkus/grafsave.png)

Give your new dashboard a name of **Quarkus Primes** and click **Save**.

# Add more Panels

See if you can add additional Panels. Use the **Add Panel** button to add a new Panel:

![Grafana UI](/openshift/assets/middleware/quarkus/grafmorepanels.png)

Follow the same steps as before to create a few more panels, and **don’t forget to Save each panel when you’ve created
it.**

Add Panels for:

  - The different quantiles of time it takes to check primes `application_org_acme_quickstart_PrimeNumberChecker_checksTimer_seconds` (configure it to *stack* its values on the *Visualization* tab, and name it "Primes Performance" on the *General* tab).
  - The Highest Prime tested so far `application_org_acme_quickstart_PrimeNumberChecker_highestPrimeNumberSoFar` (set the visualization type to `SingleStat`, and the title to `Highest So Far` on the *General* tab.
  - The JVM heap memory Value `base_memory_usedHeap_bytes` (set the visualization type to `Gauge` and the Field Units to `bytes` on the *Visualization* tab, and the title to `Memory` on the *General* tab.

# Fix layout

After saving, go back to the main dashboard (click on **Quar** at the top and then select it under *Recent
Dashboards*). Change the time value to *Last 15 Minutes* at the top-right:

![time](/openshift/assets/middleware/quarkus/graftime.png)

Finally, drag and resize the different panels to look nice and fit on a single page.

Click **Save Dashboad** again to save it. Your final Dashboard should look like:

![final](/openshift/assets/middleware/quarkus/graffinal.png)

Beautiful, and useful\! You can add many more metrics to monitor and alert for Quarkus apps using these tools.

# Congratulations\!

This exercise demonstrates how your Quarkus application can utilize the [MicroProfile
Metrics](https://github.com/eclipse/microprofile-metrics) specification through the SmallRye Metrics extension. You also
consumed these metrics using a popular monitoring stack with Prometheus and Grafana.

There are many more possibilities for application metrics, and it’s a useful way to not only gather metrics, but act on
them through alerting and other features of the monitoring stack you may be using.
