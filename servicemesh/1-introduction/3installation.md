To install Istio in the cluster, we need first to make sure that we are logged in as an `system:admin` user.

To log in the OpenShift cluster, type `oc login -u system:admin`{{execute T1}}

Now that you are logged in, it's time to extract the existing istio installation: `tar -xvzf istio-1.0.5-linux.tar.gz`{{execute T1}}

## Before the installation

Istio uses [Custom Resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/#customresourcedefinitions) like `VirtualService`s and `DestinationRule`s.

To allow OpenShift/Kubernetes to understand those values, we first need to install the 'CustomResourceDefinitions' file using the command `oc apply -f istio-1.0.5/install/kubernetes/helm/istio/templates/crds.yaml`{{execute T1}}

## Continue the installation

Istio provides a file `install/kubernetes/istio-demo.yaml` that contains the definition of all objects that needs to be created in the Kubernetes cluster.

Let's apply these definitions to the cluster by executing `oc apply -f istio-1.0.5/install/kubernetes/istio-demo.yaml`{{execute T1}}

After the execution, Istio objects will be created.

To watch the creation of the pods, execute `oc get pods -w -n istio-system`{{execute T1}}

Once that they are all `Running`, you can hit `CTRL+C`. This concludes this scenario.

## Create external routes

OpenShift uses the concept of Routes to expose HTTP services outside the cluster.

Let's create routes to external services like `Grafana`, `Prometheus`, `Tracing`, etc using the following command:

`oc expose svc istio-ingressgateway -n istio-system; \
oc expose svc servicegraph -n istio-system; \
oc expose svc grafana -n istio-system; \
oc expose svc prometheus -n istio-system; \
oc expose svc tracing -n istio-system`{{execute interrupt T1}}

## Add Istio to the path

Now we need to add `istioctl` to the path.

Execute `export PATH=$PATH:/root/installation/istio-1.0.5/bin/`{{execute interrupt T1}}.

Now try it. Check the version of `istioctl`. 

Execute `istioctl version`{{execute T1}}.

