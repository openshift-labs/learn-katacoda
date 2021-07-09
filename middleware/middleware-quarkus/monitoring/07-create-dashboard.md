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

# Open the solution in an IDE in the Cloud!
Want to continue exploring this solution on your own in the cloud? You can use the free [Red Hat CodeReady Workspaces](https://developers.redhat.com/products/codeready-workspaces/overview) IDE running on the free [Red Hat Developer Sandbox](http://red.ht/dev-sandbox). [Click here](https://workspaces.openshift.com) to login or to register if you are a new user. This free service expires after 30 days, but you can always enable a new free 30-day subscription.

Once logged in, [click here](https://workspaces.openshift.com/f?url=https://raw.githubusercontent.com/openshift-katacoda/rhoar-getting-started/solution/quarkus/monitoring/devfile.yaml) to open the solution for this project in the cloud IDE. While loading, if it asks you to update or install any plugins, you can say no.

# Fork the source code to your own GitHub!
Want to experiment more with the solution code you just worked with? If so, you can fork the repository containing the solution to your own GitHub repository by clicking on the following command to execute it:

`/root/projects/forkrepo.sh`{{execute T1}}
- Make sure to follow the prompts. An error saying `Failed opening a web browser at https://github.com/login/device exit status 127` is expected.
- [Click here](https://github.com/login/device) to open a new browser tab to GitHub and paste in the code you were presented with and you copied.
- Once done with the GitHub authorization in the browser, close the browser tab and return to the console and press `Enter` to complete the authentication process.
- If asked to clone the fork, press `n` and then `Enter`.
- If asked to confirm logout, press `y` and the `Enter`.

   > **NOTE:** This process uses the [GitHub CLI](https://cli.github.com) to authenticate with GitHub. The learn.openshift.com site is not requesting nor will have access to your GitHub credentials.

After completing these steps the `rhoar-getting-started` repo will be forked in your own GitHub account. On the `solution` branch in the repo, the `monitoring` project inside the `quarkus` folder contains the completed solution for this scenario.

# Congratulations\!

This exercise demonstrates how your Quarkus application can utilize the [Micrometer
Metrics extension](https://quarkus.io/guides/micrometer) to visualize metrics for Quarkus applications. You also
consumed these metrics using a popular monitoring stack with Prometheus and Grafana and other APM tools that support Micrometer.

There are many more possibilities for application metrics, and it’s a useful way to not only gather metrics, but act on
them through alerting and other features of the monitoring stack you may be using.
