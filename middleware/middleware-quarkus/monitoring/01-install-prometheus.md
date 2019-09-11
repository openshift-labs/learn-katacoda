## Login to OpenShift

**Red Hat OpenShift Container Platform** is the preferred container orchestration platform for Quarkus. OpenShift is based on **Kubernetes** which is the most used Orchestration
for containers running in production.

In order to login, we will use the **oc** command and then specify the server that we
want to authenticate to:

`oc login [[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com --insecure-skip-tls-verify=true`{{execute}}

Enter your username and password:
* Username: **developer**
* Password: **developer**

Congratulations, you are now authenticated to the OpenShift server.

## Access OpenShift Project

[Projects](https://docs.openshift.com/container-platform/3.11/architecture/core_concepts/projects_and_users.html#projects)
are a top level concept to help you organize your deployments. An
OpenShift project allows a community of users (or a user) to organize and manage
their content in isolation from other communities.

For this scenario, let's create a project that you will use to house your applications. Click:

`oc new-project quarkus --display-name="Sample Monitored Quarkus App"`{{execute}}

## Create Prometheus Configuration

Next, let’s install Prometheus. Prometheus is an open-source systems monitoring and alerting toolkit featuring:

  - a multi-dimensional [data model](https://prometheus.io/docs/concepts/data_model/) with time series data identified by metric name and key/value pairs

  - [PromQL](https://prometheus.io/docs/prometheus/latest/querying/basics/), a flexible query language to leverage this dimensionality

  - time series collection happens via a pull model over HTTP

To install it, first create a Kubernetes ConfigMap that will hold the Prometheus configuration. Click on the following command to create this file:

```
cat <<EOF > /tmp/prometheus.yml
global:
  scrape_interval:     15s
  evaluation_interval: 15s
alerting:
  alertmanagers:
  - static_configs:
    - targets:
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
    - targets: ['localhost:9090']
  - job_name: 'hello-app'
    static_configs:
    - targets: ['primes:8080']
EOF
```{{execute}}

This file contains basic Prometheus configuration, plus a specific `scrape_config` which instructs Prometheus to
look for application metrics from both Prometheus itself, and a Quarkus app called `primes` which we'll create later, on HTTP port 8080 at the `/metrics`
endpoint.

Next, click this command to create a ConfigMap with the above file:

`oc create configmap prom --from-file=prometheus.yml=/tmp/prometheus.yml`{{execute}}

## Deploy Prometheus

Next, deploy and expose Prometheus using its public Docker Hub image:

`oc new-app prom/prometheus && oc expose svc/prometheus`{{execute}}

And finally, mount the ConfigMap into the running container:

`oc set volume dc/prometheus --add -t configmap --configmap-name=prom -m /etc/prometheus/prometheus.yml --sub-path=prometheus.yml`{{execute}}

This will cause the contents of the ConfigMap data to be mounted at `/etc/prometheus/prometheus.yml` inside its container
where Prometheus is expecting it.

Verify Prometheus is up and running:

`oc rollout status -w dc/prometheus`{{execute}}

You should see `replication controller "prometheus-2" successfully rolled out`.

> If this command appears to hang, just press `CTRL-C` and click it again.
