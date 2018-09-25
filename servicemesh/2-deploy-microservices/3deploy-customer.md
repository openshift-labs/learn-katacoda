Go to the source folder of `customer` microservice.

Execute: `cd ~/projects/istio-tutorial/customer/java/springboot`{{execute T1}}

Now execute `mvn package`{{execute T1}} to create the `customer.jar` file.

## Create the customer docker image.

We will now use the provided `/customer/java/springboot/Dockerfile`{{open}} to create a docker image.

This image will be called `example/customer`.

To build a docker image type: `docker build -t example/customer .`{{execute T1}}

You can check the image that was create by typing `docker images | grep customer`{{execute T1}}

## Injecting the sidecar proxy.

Currently using the "manual" way of injecting the Envoy sidecar.

Check the version of `istioctl`. Execute `istioctl version`{{execute T1}}.

Also, make sure that you are using `tutorial` project. Execute `oc project tutorial`{{execute T1}}

Now let's deploy the customer pod with its sidecar.

Execute: `oc apply -f <(istioctl kube-inject -f ../../kubernetes/Deployment.yml) -n tutorial`{{execute T1}}

Also create a service: `oc create -f ../../kubernetes/Service.yml`{{execute T1}} 

Since customer is the forward most microservice (customer -> preference -> recommendation), let's add an OpenShift Route that exposes that endpoint.

Execute: `oc expose service customer`{{execute T1}}.

Check the route: `oc get route`{{execute T1}}

To watch the creation of the pods, execute `oc get pods -w`{{execute T1}}

Once that the customer pod READY column is 2/2, you can hit `CTRL+C`. 

Try the microservice by typing `curl http://customer-tutorial.[[HOST_SUBDOMAIN]]-80-[[KATACODA_HOST]].environments.katacoda.com`{{execute interrupt T1}}

You should see the following error because the services `preference` and `recommendation` are not yet deployed.

`customer => I/O error on GET request for "http://preference:8080": preference; nested exception is java.net.UnknownHostException: preference`

This concludes the deployment of the `customer` microservice.
