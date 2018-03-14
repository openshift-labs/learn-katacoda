There are two examples of egress routing, one for httpbin.org and one for github. Egress routes allow you to apply rules to how internal services interact with external APIs/services.

Create a namespace/project to hold these egress examples

`oc new-project istioegress`{{execute T1}}

Don't foget to add the `privileged` SCC to this project.

`oc adm policy add-scc-to-user privileged -z default -n istioegress`{{execute T1}}

## Create HTTPBin Java App

Go to the source folder of `egresshttpbin` microservice.

Execute: `cd ~/projects/istio-tutorial/egress/egresshttpbin/`{{execute T1}}

Now execute `mvn package`{{execute T1}} to create the fat jar.

## Create the egresshttpbin docker image.

We will now use the provided `/egress/egresshttpbin/Dockerfile`{{open}} to create a docker image.

This image will be called `example/egresshttpbin:v1`.

To build a docker image type: `docker build -t example/egresshttpbin:v1 .`{{execute T1}}

You can check the image that was create by typing `docker images | grep egress`{{execute T1}}


## Deploying the project in OpenShift

Now let's deploy this project.

Execute: `oc apply -f <(istioctl kube-inject -f src/main/kubernetes/Deployment.yml) -n istioegress`{{execute T1}}

Also create a service: `oc create -f src/main/kubernetes/Service.yml`{{execute T1}} 

Let's add an OpenShift Route that exposes that endpoint.

Execute: `oc expose service egresshttpbin`{{execute T1}}.

Check the route: `oc get route`{{execute T1}}

To watch the creation of the pods, execute `oc get pods -w`{{execute T1}}

Once that the customer pod READY column is 2/2, you can hit `CTRL+C`. 

Try the microservice by typing `curl http://egresshttpbin-istioegress.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute interrupt T1}}

**Note:** It does not work...yet. Envoy blocks egress due to security concerns, but later we will add a Egress rule to allow this access.
