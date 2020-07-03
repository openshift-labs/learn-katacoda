At the end of this chapter you will be able to:
- Create your own `Helm Chart`
- Manage multiple `Helm Revisions` for your Helm Chart
- Understand `Helm Templates`
- Understand Helm integrations with `Kubernetes`


After having discovered `helm` CLI to install and manage Helm Charts, we can now create our first one from scratch. Before doing that, let's review Helm core concepts from [official documentation](https://helm.sh/docs/topics/charts/):

- A `Chart` is a Helm package. It contains all of the resource definitions necessary to run an application, tool, or service inside of a Kubernetes cluster.
- A `Repository` is the place where charts can be collected and shared.
- A `Release` is an instance of a chart running in a Kubernetes cluster- 


Helm uses a packaging format called charts. A chart is a collection of files that describe a related set of Kubernetes resources, and it organized as a collection of files inside of a directory. The directory name is the name of the chart.

## Create your first Helm Chart

As example, let's create our own NGINX Chart, just launching this command with `helm` CLI:

`helm create mychart`{{execute}}

This will create the base structure for a new Helm Chart, that we can manipulate and customize through `Helm Template` system.

Inside `mychart/` folder you will find these files:

`tree mychart`{{execute}}

* `Chart.yaml`: is a YAML file containing multiple fields describing the chart
* `values.yaml`: is a YAML file containing default values for a chart, those may be overridden by users during helm install or helm upgrade.
* `templates/NOTES.txt`: a test to be displayed to your users when they run helm install.
* `templates/deployment.yaml`: a basic manifest for creating a Kubernetes deployment
* `templates/service.yaml`: a basic manifest for creating a service endpoint for your deployment
* `templates/_helpers.tpl`: a place to put template helpers that you can re-use throughout the chart

This command generates a skeleton of your Helm Chart, and by default there is an NGINX image as example:

Let's review generated `Chart.yaml`{{open}}

And `values.yaml`{{open}}


Now let's change this image to use `bitnami/nginx` from previous chapter, modifying field `image.repository` from `values.yaml`: 

`sed -i 's/nginx/bitnami\/nginx/' mychart/values.yaml`{{execute}}

And install our custom Helm Chart:

`helm install mychart ./mychart`{{execute}}

This will install NGINX like in previous chapter, and we can follow installation like before:

`oc get pods`{{execute}}

Review installed revision:

`helm ls`{{execute}}

## Upgrade and Rollback revisions

When we install a Helm Chart on OpenShift, we publish a release into the cluster that we can control in terms of upgrades and rollbacks.

To change something in any already published chart, we can use `helm upgrade` command with parameters to inject dynamically in our `values.yaml`.

Let's update our existing release changing `image.pullPolicy` from chart's default value `IfNotPresent` to `Always`, using same method we adopted previously for changing `service.type` with option `--set`:

`helm upgrade mychart ./mychart --set image.pullPolicy=Always`{{execute}}

Let's verify that our changes is reflected into resulting `Deployment`:

`oc get deployment mychart -o yaml | grep imagePullPolicy`{{execute}}

Now that our new release is published and verified, we can decide to rollback it if we need to with `helm rollback` command.

It is also possible to dry-run the rollback with `--dry-run` option:

`helm rollback mychart 1 --dry-run`{{execute}}

Rollback to starting revision:

`helm rollback mychart 1`{{execute}}




