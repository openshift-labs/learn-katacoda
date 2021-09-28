# Install Grafana

We'll keep our prime number checker running. Click to run the following command in the other Terminal to deploy Grafana to our cluster:

`oc new-app quay.io/bitnami/grafana && oc expose svc/grafana`{{execute T2}}

> It may take up to a minute to finish deploying

Verify Grafana is up and running:

`oc rollout status -w deployment/grafana`{{execute}}

You should see `replication controller "grafana-1" successfully rolled out`

# Open Grafana Dashboard

Click on this link to [open the Grafana Dashboard in your browser](http://grafana-quarkus.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com/), and login using the default credentails:

  - Username: `admin`
  - Password: `admin`

![Grafana UI](/openshift/assets/middleware/quarkus/graflogin.png)

At the password change prompt, use any password you wish.

# Add Prometheus as a data source

You’ll land on the Data Source screen. Click **Add your first data source**, and click **Select** next to **Prometheus** as the *Data Source Type*.

In the URL box, type ``http://prometheus:9090``{{copy}} (this is the hostname and port of our running Prometheus in our
namespace):

> **WARNING**
>
> If you skip this step, you'll get errors and things won't work! Make sure to change it to ``http://prometheus:9090``{{copy}}!

![Grafana UI](/openshift/assets/middleware/quarkus/grafds.png)

Click **Save and Test**. You should see:

![Grafana UI](/openshift/assets/middleware/quarkus/grafworking.png)

With our data source working, let’s make a dashboard.

