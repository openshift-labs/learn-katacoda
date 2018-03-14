Go to the source folder of `egresshttpbin` microservice.

Execute: `cd ~/projects/istio-tutorial/egress/egressgithub/`{{execute T1}}

Now execute `mvn package`{{execute T1}} to create the fat jar.

## Create the egressgithub docker image.

We will now use the provided `/egress/egressgithub/Dockerfile`{{open}} to create a docker image.

This image will be called `example/egressgithub:v1`.

To build a docker image type: `docker build -t example/egressgithub:v1 .`{{execute T1}}

You can check the image that was create by typing `docker images | grep egress`{{execute T1}}

## Deploying the project in OpenShift

Now let's deploy this project.

Execute: `oc apply -f <(istioctl kube-inject -f src/main/kubernetes/Deployment.yml) -n istioegress`{{execute T1}}

Also create a service: `oc create -f src/main/kubernetes/Service.yml`{{execute T1}} 

Let's add an OpenShift Route that exposes that endpoint.

Execute: `oc expose service egressgithub`{{execute T1}}.

Check the route: `oc get route`{{execute T1}}

To watch the creation of the pods, execute `oc get pods -w`{{execute T1}}

Once that the customer pod READY column is 2/2, you can hit `CTRL+C`. 

Try the microservice by typing `curl http://egressgithub-istioegress.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute interrupt T1}}

**Note:** It will not work now but it will once Istio-ized
