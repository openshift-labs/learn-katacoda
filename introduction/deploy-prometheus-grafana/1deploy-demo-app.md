## Playing with the demo application

The Demo application is a very simple ecommerce application that also exposes some of it's metrics. (The demo application might take up to an additional minute to be initialized)

### Generating some Metrics

The url for the demo appplication is: http://metrics-demo-app-metrics-demo.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/

![Demo Application Home Page](../../assets/introduction/deploy-prometheus-grafana/01-demo-app-home-page.png)

* Once you are able to access the ecommerce demo application, play around with it,
try to buy the products you like [Everything here is free ;) ].
* When you play around with the application, you make the server serve some requests (GET/POST/..), <br>
some of the metrics for these requests are generated and exposed for Prometheus to collect.

### Exposed Metrics
The exposed metrics can be found here: http://metrics-demo-app-metrics-demo.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/metrics

* This is the page where prometheus will scrape (collect) metrics from periodically and store them in a Timestamp Database.

![Demo Application Metrics Page](../../assets/introduction/deploy-prometheus-grafana/01-demo-app-metrics-page.png)

* If you don't see similar metrics (pictured above ^) in your environment, play with ecommerce application a little more to generate a few metrics.
